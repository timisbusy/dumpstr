mongo-uri
=========

I parse mongo URIs; especially the tricky repl set ones.  
[![Build Status](https://travis-ci.org/supershabam/mongo-uri.png?branch=master)](https://travis-ci.org/supershabam/mongo-uri)

Dear NodeJS MongoDB Drivers
---------------------------

I want to use the mongodb connection string... and not just the simple `mongodb://localhost`.

As it turns out, as soon as you start working with real... non-localhost/side-project
deployments, you need to connect to replication sets. Luckily the defined connection
string format accomodates such configurations!

Sadly, you do not understand these connection strings, or have unacceptable bugs with
your parsing (e.g. uris are uri encoded).

So, I made a uri parser for you.

Please find bugs in my code, and help me make it the best mongo connection string
parser in history.

AND THEN USE IT!

Heads up
--------

I refuse to make assumptions about defaults as part of the parser. So, if a port
goes unspecified, I will say that the port is null (because it is), and it is
your job to realize that the default port is 27015.

Usage
-----

```javascript
var MongoURI = require('mongo-uri')
  , uriString
  , uri
  ;

// let's deal with a complicated (yet real-life) uri
uriString = "mongodb://%40u%2Fs%3Fe%3Ar:p%40a%2Fs%3Fs%3A@example1.com,example2.com,example3.com:27018/?readPreference=secondary&w=2&wtimeoutMS=2000&readPreferenceTags=dc:ny,rack:1&readPreferenceTags=dc:ny&readPreferenceTags=";

try {
  uri = MongoURI.parse(uriString);
} catch (err) {
  // handle this correctly, kthxbye
}

console.log(uri);
/*
 * username: "@u/s?e:r" // yay! it got decoded like it was supposed to!
 * password: "p@a/s?s:"
 * hosts: ["example1.com", "example2.com", "example3.com"] // wow, multiple hosts!
 * ports: [null, null, 27018] // remember, I don't assume
 * database: null // what did I just say?
 * options: {
 *   readPreference: "secondary",
 *   w: "2",
 *   timeoutMS: "2000",
 *   readPreferenceTags: ["dc:ny,rack:1", "dc:ny", ""] // yeah, this is correct
 * }
 */
```

Source
------

Ok, so I made a Tweet (which is as good as a promise) that my next npm module would
be in [literate coffeescript](http://ashkenas.com/literate-coffeescript/). So,
I had fun documenting my code, but I *do not* want the .litcoffee to be transpiled
upon `npm install` of everbody using this code.

GitHub should store the raw source (without the transpiled lib/*.js contents), but
npm should store the ready-to-use no-transpiling-needed javascript!

So, I created a grunt task to do my publishing. Instead of using `npm publish`, I
use `grunt publish` which cleans my directory, compiles my .litcoffee files, and
then publishes.

So, don't hate me for using .litcoffee. You're getting raw javascript goodness
when you npm install me.

License
-------

MIT
