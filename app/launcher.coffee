###
The Launcher loads and starts each Source Handler from `handlers/`. Sources
are defined as a type (matching a handler), and additional parameters,
allowing multiple tracks to be set up for the same kind of source.
(Some sources are exclusive, like the Twitter Streaming API.)

The Handlers can use a streaming connection, polling, or whatever to retrieve
data items. Each handler instance is given a function to use for saving the
items, which attaches some meta information and turns the item into a Report,
for later processing.
###



{ MongoClient } = require 'mongodb'
util            = require 'util'

env = require '../env'



# Map the handler classes to their type names. (The Twitter one is called
# 'twitterstream' since its behavior is notably distinct from the Twitter REST
# API.)
source_handlers = {}
['twitterstream', 'facebook'].forEach (name) ->
    source_handlers[name] = require "../handlers/#{ name }"

# For now, Sources are hardcoded. Eventually, these will move to data with the
# creation of the internal admin tools.
sources = require './sources'



# Internal: Generates the save function used by the handler (as a way to
# abstract the implementation of the saving from the handler).
#
# collection - the MongoDB collection to use
#
# Returns the save function.
_getInsertFn = (collection) ->

    # Public: the actual save function that gets called by the handler to save
    # a single data item (a tweet, FB post, email, sms, etc). The Report gets
    # saved with an ID of the form `<source_type>:<id_from_source>`.
    #
    # source    - the object Source specifying the data source
    # data      - the object raw data for a single item from a Source
    # id_to_use - (null) a String ID to use instead of the `data.id` property
    #               (with Twitter, the ID is too big for JS representation
    #                as a number, so Twitter provides an alternate string)
    #
    # The report looks something like this:
    #
    #    {
    #        "_id"              : "twitterstream:378782637894414337",
    #        "source_id"        : "twitterstream:1",
    #        "status"           : "unprocessed"
    #        "created_date"     : ISODate("2013-09-14T07:29:43.353Z"),
    #        "modified_date"    : ISODate("2013-09-14T07:29:43.353Z"),
    #        "data"             : { ... raw tweet ... }
    #    }
    #
    # Returns nothing.
    return (source, data, id_to_use=null) ->

        unless id_to_use?
            id_to_use = data.id

        resource_id = "#{ source.type }:#{ id_to_use }"

        update_query =
            _id: resource_id

        # Set on insert in case the Report has already been recorded. The
        # incoming data should be the same, so we don't want to modify the
        # control properties (like `status` or `created_date`).
        update_data =
            $setOnInsert:
                source_id       : source._id
                modified_date   : new Date()
                created_date    : new Date()
                status          : 'unprocessed'
                data            : data

        update_options =
            upsert: true

        collection.update update_query, update_data, update_options, (err, result) ->
            throw err if err?



util.log 'Connecting to MongoDB'
MongoClient.connect env.MONGODB_URL, (err, db) ->
    throw err if err?

    util.log 'Connecting to Collection'
    db.createCollection 'reports', (err, collection) ->
        throw err if err?

        util.log 'Launching Source handlers'
        launched = {}

        sources.forEach (source) ->

            handler_class = source_handlers[source.type]

            # Avoid launching multiple sources of eclusive types.
            unless handler_class.exclusive and launched[source.type]?
                handler = new handler_class( _getInsertFn(collection) )
                handler.start(source)
                launched[source.type] ?= []
                launched[source.type].push(source)

                util.log "Launched #{ source._id }"
