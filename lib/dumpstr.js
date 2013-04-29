var conf = require('./conf.js')
  , ms = require('./mongoStream')
  , ds = require('./dumpStream')
  , mi = require('./mongoInfo')
  , parseUri = require('mongo-uri').parse;

function dump (mongoUri, path, cb) {
  var uriInfo = parseUri(mongoUri)
    , processingCollections
    , failures = {};

  mi.getCollections(uriInfo, function (err, collections) {
    if (err) { return cb(err); }
    processingCollections = collections;
    dumpCollections();
  });

  function dumpCollections () {
    if (processingCollections.length > 0) {
      var collection = processingCollections.splice(0,1)[0];
      var collectionName = collection.name.substring(collection.name.indexOf('.') + 1);
      // console.log(collectionName);
      ms.getStream(uriInfo, collectionName, function (err, stream) {
        if (err) { addToFailed(collectionName, err); }
        ds.dump(stream, path + '/' + collectionName + '.bson', function (err, res) {
          // console.log('callback for ', collectionName, ' here.');
          if (err) { return addToFailed(collectionName, err); }
          if (!res) { return addToFailed(collectionName,  new Error("No response from Amazon! " + JSON.stringify(arguments))); }
          if (!res.Key) { return addToFailed(collectionName, new Error("No Key on response from Amazon! " + res.Code + ": " + res.Message)); }
          dumpCollections();
        })
      });
    } else {
      cb(null, failures);
    }
  }


  function addToFailed (collectionName, err) {
    // console.log(err); 
    // console.trace(); 
    failures[collectionName] = err;
    dumpCollections();
  }
}

module.exports = {
    dump: dump
  , setConfig: conf.setConfig
}