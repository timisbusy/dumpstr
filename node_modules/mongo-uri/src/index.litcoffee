I'm the entrypoint file. When you require('mongo-uri'), I am what you get. So,
I should expose to you everything you'd ever want.

Let's just pull in our friends here
    MongoUri = require "./mongo-uri"

And now we'll expose the classes we created, and the parse method from MongoUri,
which is really just a static method.

    exports = module.exports =
      MongoUri: MongoUri
      parse: MongoUri.parse
