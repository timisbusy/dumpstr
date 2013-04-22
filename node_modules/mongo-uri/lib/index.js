(function() {
  var MongoUri, exports;

  MongoUri = require("./mongo-uri");

  exports = module.exports = {
    MongoUri: MongoUri,
    parse: MongoUri.parse
  };

}).call(this);
