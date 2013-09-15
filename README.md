Hoboken CM: Crowd Reporting
===========================

The Crowd Reporting package runs a service that pulls posts from sources
like Twitter and saves the posts as Reports. Other tools can then process
the stored Reports, classifying, displaying, and so on.


## Usage

Requires:

* [MongoDB](http://www.mongodb.org/)
* [Node.js](http://nodejs.org/)

(On a Mac, the easiest way to install them is [homebrew](http://brew.sh/).)

1.  Clone the project:

        $ git clone git@github.com:HobokenCM/crowd-reporting.git
        $ cd crowd-reporting

2.  Create an `env.coffee` file in the project root that follows this template:

        module.exports =
            TWITTER_CONSUMER_KEY        : ''
            TWITTER_CONSUMER_SECRET     : ''
            TWITTER_ACCESS_TOKEN_KEY    : ''
            TWITTER_ACCESS_TOKEN_SECRET : ''
            MONGODB_URL                 : 'mongodb://localhost:27017/sandy'

    The Twitter settings require registering as a developer and setting up an
    [app](https://dev.twitter.com/apps). The MongoDB URL will work if `mongod`
    is running using the defaults. Otherwise, replace it with the correct URL.

3.  Install the node dependencies using [`npm`](https://npmjs.org/):

        $ npm install

    This will install the dependencies listed in `package.json`.

4.  Start the Sources:

        $ coffee app/launcher.coffee


## More info

* [Twitter Streaming API](https://dev.twitter.com/docs/streaming-apis)


## Notes

Potential data sources:
* Twitter
* Facebook
* Email
* Instagram
* SMS
* News
* Other (manual report entry)
