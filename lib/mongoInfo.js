var MongoClient = require('mongodb').MongoClient;

function getCollections (uri, cb) {
  establishConnection(uri, function (err, client) {
    if (err) { return cb(err); }
    client.collectionNames(function(error, result) {
    	cb(error, result);
    	client.close();
    });
  });
}

function establishConnection (uri, cb) {

  MongoClient.connect(uri, cb);

}

module.exports = {
  getCollections: getCollections
}
