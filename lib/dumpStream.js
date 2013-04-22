var knox = require('knox')
  , MultiPartUpload = require('knox-mpu')
  , conf = require('./conf');

function dumpStream (stream, filepath, cb) {

  var client = knox.createClient(conf.aws());

  var upload = new MultiPartUpload(
      {
          client: client,
          objectName: filepath, // Amazon S3 object name
          stream: stream
      }, cb
  );

}

module.exports.dump = dumpStream;