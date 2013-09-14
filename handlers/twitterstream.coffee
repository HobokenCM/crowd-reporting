Twitter = require 'ntwitter'
util    = require 'util'

env = require '../env'



# Public: A Source handler that consumes the Twitter Streaming API.
#
# report_save_fn - the Function to call for saving the Report (avoids needing
#                   to pass around an asynchronously established db connection).
#
class TwitterStreamingHandler
    @exclusive = true

    constructor: (report_save_fn) ->
        @_saveReport = report_save_fn

    # Public: begin pulling data.
    #
    # source - an Object describing the source
    #         _id         - the String ID of the source
    #         parameters  - an Object of arguments for `status/filter` endpoint
    #
    # Returns nothing.
    start: (source) ->
        twit = new Twitter
            consumer_key          : env.TWITTER_CONSUMER_KEY
            consumer_secret       : env.TWITTER_CONSUMER_SECRET
            access_token_key      : env.TWITTER_ACCESS_TOKEN_KEY
            access_token_secret   : env.TWITTER_ACCESS_TOKEN_SECRET

        util.log "#{ source._id } - Starting"
        twit.stream 'statuses/filter', source.params, (stream) =>
            util.log "#{ source._id } - stream connected"
            stream.on 'data', (data) => @_saveReport(source, data, data.id_str)



module.exports = TwitterStreamingHandler



###
Sample tweet structure:

    {
       "created_at":"Sat Sep 14 07:29:52 +0000 2013",
       "id":378782637894414340,
       "id_str":"378782637894414337",
       "text":"@hobokencm #test hurricane http://t.co/1Ns8OeSwWw $TEST http://t.co/ciaiTu9yg2",
       "source":"<a href=\"http://twitterrific.com\" rel=\"nofollow\">Twitterrific</a>",
       "truncated":false,
       "in_reply_to_status_id":null,
       "in_reply_to_status_id_str":null,
       "in_reply_to_user_id":29083303,
       "in_reply_to_user_id_str":"29083303",
       "in_reply_to_screen_name":"HobokenCM",
       "user":{
          "id":14848078,
          "id_str":"14848078",
          "name":"Alec Perkins",
          "screen_name":"alecperkins",
          "location":"Hoboken, NJ",
          "url":"http://alecperkins.net",
          "description":"Designer with a coding problem. Building tools at @marquee.",
          "protected":false,
          "followers_count":670,
          "friends_count":697,
          "listed_count":41,
          "created_at":"Tue May 20 18:12:45 +0000 2008",
          "favourites_count":2686,
          "utc_offset":-14400,
          "time_zone":"Eastern Time (US & Canada)",
          "geo_enabled":true,
          "verified":false,
          "statuses_count":18849,
          "lang":"en",
          "contributors_enabled":false,
          "is_translator":false,
          "profile_background_color":"FFFFFF",
          "profile_background_image_url":"http://a0.twimg.com/profile_background_images/77767199/Untitled-1.png",
          "profile_background_image_url_https":"https://si0.twimg.com/profile_background_images/77767199/Untitled-1.png",
          "profile_background_tile":false,
          "profile_image_url":"http://a0.twimg.com/profile_images/2802246597/b859c0f92bef959a6edd3cca07e752f1_normal.png",
          "profile_image_url_https":"https://si0.twimg.com/profile_images/2802246597/b859c0f92bef959a6edd3cca07e752f1_normal.png",
          "profile_link_color":"002196",
          "profile_sidebar_border_color":"000000",
          "profile_sidebar_fill_color":"EEEEEE",
          "profile_text_color":"000000",
          "profile_use_background_image":false,
          "default_profile":false,
          "default_profile_image":false,
          "following":null,
          "follow_request_sent":null,
          "notifications":null
       },
       "geo":{
          "type":"Point",
          "coordinates":[
             40.747058,
             -74.037343
          ]
       },
       "coordinates":{
          "type":"Point",
          "coordinates":[
             -74.037343,
             40.747058
          ]
       },
       "place":{
          "id":"e9143a85705b4d40",
          "url":"https://api.twitter.com/1.1/geo/id/e9143a85705b4d40.json",
          "place_type":"city",
          "name":"Hoboken",
          "full_name":"Hoboken, NJ",
          "country_code":"US",
          "country":"United States",
          "bounding_box":{
             "type":"Polygon",
             "coordinates":[
                [
                   [
                      -74.044117,
                      40.730321
                   ],
                   [
                      -74.044117,
                      40.759099
                   ],
                   [
                      -74.013784,
                      40.759099
                   ],
                   [
                      -74.013784,
                      40.730321
                   ]
                ]
             ]
          },
          "attributes":{

          }
       },
       "contributors":null,
       "retweet_count":0,
       "favorite_count":0,
       "entities":{
          "hashtags":[
             {
                "text":"test",
                "indices":[
                   11,
                   16
                ]
             }
          ],
          "symbols":[
             {
                "text":"TEST",
                "indices":[
                   50,
                   55
                ]
             }
          ],
          "urls":[
             {
                "url":"http://t.co/1Ns8OeSwWw",
                "expanded_url":"http://example.com",
                "display_url":"example.com",
                "indices":[
                   27,
                   49
                ]
             }
          ],
          "user_mentions":[
             {
                "screen_name":"HobokenCM",
                "name":"Hoboken Crisis Maps",
                "id":29083303,
                "id_str":"29083303",
                "indices":[
                   0,
                   10
                ]
             }
          ],
          "media":[
             {
                "id":378782637449830400,
                "id_str":"378782637449830400",
                "indices":[
                   56,
                   78
                ],
                "media_url":"http://pbs.twimg.com/media/BUG0zUhIYAAcUjD.png",
                "media_url_https":"https://pbs.twimg.com/media/BUG0zUhIYAAcUjD.png",
                "url":"http://t.co/ciaiTu9yg2",
                "display_url":"pic.twitter.com/ciaiTu9yg2",
                "expanded_url":"http://twitter.com/alecperkins/status/378782637894414337/photo/1",
                "type":"photo",
                "sizes":{
                   "large":{
                      "w":768,
                      "h":1024,
                      "resize":"fit"
                   },
                   "medium":{
                      "w":600,
                      "h":800,
                      "resize":"fit"
                   },
                   "thumb":{
                      "w":150,
                      "h":150,
                      "resize":"crop"
                   },
                   "small":{
                      "w":340,
                      "h":453,
                      "resize":"fit"
                   }
                }
             }
          ]
       },
       "favorited":false,
       "retweeted":false,
       "possibly_sensitive":false,
       "filter_level":"medium",
       "lang":"en"
    }

###
