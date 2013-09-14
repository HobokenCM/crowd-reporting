util    = require 'util'

env = require '../env'



class FacebookSearchHandler
    @exclusive = false

    constructor: (report_save_fn) ->
        @_saveReport = report_save_fn

    start: (source) ->
        throw new Error 'Not implemented'



module.exports = FacebookSearchHandler
