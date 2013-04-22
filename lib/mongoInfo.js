var mongodb = require('mongodb');

function getCollections (uriInfo, cb) {
  establishConnection(uriInfo, function (err, client) {
    if (err) { return cb(err); }
    client.collectionNames(cb);
  });
}

function establishConnection (uriInfo, cb) {

  var server = new mongodb.Server(uriInfo.hosts[0], uriInfo.ports[0] || 27017, {});

  new mongodb.Db(uriInfo.database, server, { safe: false }).open(function (err, client) {
    if (err) { return cb(err); }
    if (uriInfo.username) {
      client.authenticate(uriInfo.username, uriInfo.password, function (err) {
        if (err) { return cb(err); }
        cb(null, client);
      });
    } else {
      cb(null, client);
    }
  });

}

module.exports = {
  getCollections: getCollections
}