The mongodb connection string URI is a little different than a typical URI but
does actually conform to the URI scheme. Because of it's a-typical nature, 
namely, being able to specify multiple hosts, it's rare to see in NodeJS land
a driver that correctly parses a mongo uri :(

Resources:
* http://docs.mongodb.org/manual/reference/connection-string/
* http://en.wikipedia.org/wiki/URI_scheme
* http://tools.ietf.org/html/std66

## URI Connection Scheme
`mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]`

## concerning defaults
This parser will not assume any defaults for you. 

**Example**  
If a port is not set, then it will be set to `null`. It is the caller's job to 
know that mongo's default port is 27015 and to use that when the port is `null`.

- - -

Dependencies
------------
    querystring = require "querystring"


Regular Expressions
-------------------

Here we define some regular expressions to use in parsing. They are defined here
so that we only have to create them once.

This matches if the string starts with mongodb://

    RE_PULL_MONGODB_SCHEME = /^mongodb:\/\/(.*)$/i

This will match if there is an auth portion to the string, and have username,
password, and the rest of the uri as match results.

    RE_PULL_MONGODB_AUTH = /^([^:\/\?,]+):([^@\/\?,]+)@(.*)$/

This will pull out everything before a / or ? character, which is the hostname
portion.

    RE_PULL_HOSTNAME_PORTION = /^([^\/\?]+)(.*)$/

This will test and see if there is a database (path) portion of the uri after
pulling out the previous pieces. If it matches, match[1] will contain the database
and match[2] will be the rest of the uri

    RE_PULL_DATABASE = /^\/([^?]*)($|\?.*$)/

This checks if there is a ? to signify a querystring and returns the proceeding
key=value&key=value string that follows

    RE_PULL_OPTIONS = /^\?(.*)$/

MongoUri
--------

This is really just a placeholder object so that we get a pretty prototype.

    exports.MongoUri = class MongoUri
      constructor: ->
        @username = null
        @password = null
        @hosts = null
        @ports = null
        @database = null
        @options = null

parse
-----

This is where the magic happens!

*throws*
* TypeError - if uri isn't a string or is malformed

    exports.parse = (uri)->
      throw new TypeError("Parameter 'uri' must be a string, not #{typeof uri}") unless typeof uri is "string"

Create the MongoUri object that we will return assuming everything is formatted
correctly

      mongoUri = new exports.MongoUri()

Trim the uri before proceeding.

      uri = uri.trim()

Run through each of our uri puller methods to consume the uri and add the pieces
to our resulting mongoUri object

      uri = exports._pullMongodbScheme(uri)
      [mongoUri.username, mongoUri.password, uri] = exports._pullAuth(uri)
      [mongoUri.hosts, mongoUri.ports, uri] = exports._pullHostnames(uri)
      [mongoUri.database, uri] = exports._pullDatabase(uri)
      [mongoUri.options] = exports._pullOptions(uri)


We made it without throwing an error! You truely deserve this
      return mongoUri


_pullMongodbScheme(uri)
-----------------------

returns the uri with the scheme portion removed

*throws*
* TypeError - if the uri doesn't start with mongodb://

    exports._pullMongodbScheme = (uri)->
      matches = uri.match RE_PULL_MONGODB_SCHEME
      throw new TypeError("uri must be mongodb scheme") unless matches?.length is 2
      return matches[1]

_pullAuth
---------

extracts the username and password (if exists) from a uri. Assumes that pullScheme
has already been run.

*throws*
* URIError - if the values in the username or password are invalid URI encoded
values

    exports._pullAuth = (uri)->
      matches = uri.match RE_PULL_MONGODB_AUTH
      return [null, null, uri] if matches is null
      username = decodeURIComponent matches[1]
      password = decodeURIComponent matches[2]
      uri = matches[3]
      return [username, password, uri]

_pullHostnames
--------------

extracts all the hosts and their ports. Assumes that pullScheme and pullAuth has
been executed. 

Though, drivers can technically connect over a unix socket, I find the use case 
for this rare and stupid, so I am not going to handle it.

*throws*
* TypeError - if there is no hostname to be found

    exports._pullHostnames = (uri)->
      matches = uri.match RE_PULL_HOSTNAME_PORTION
      throw new TypeError("uri must specify hostname") unless matches?.length is 3
      hostnames = matches[1].split(",")
      uri = matches[2]
      hosts = []
      ports = []
      for hostname in hostnames
        if hostname.indexOf(":") is -1
          port = null
          host = hostname
        else
          [host, port] = hostname.split(":")
          port = parseInt(port, 10)
        hosts.push host
        ports.push port
      return [hosts, ports, uri]

_pullDatabase
-------------

extracts the database from the uri, which is optional.

    exports._pullDatabase = (uri)->
      matches = uri.match RE_PULL_DATABASE
      return [null, uri] if matches is null
      database = matches[1]
      uri = matches[2]
      database = if database.length then database else null
      return [database, uri]

_pullOptions
------------

Gets the querystring options. This is one place where we will delegate to other
code: the querystring module.

    exports._pullOptions = (uri)->
      matches = uri.match RE_PULL_OPTIONS
      return [Object.create(null)] if matches is null
      options = querystring.parse(matches[1])
      return [options]

