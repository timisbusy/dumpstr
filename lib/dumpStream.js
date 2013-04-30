var knox = require('knox')
  , MultiPartUpload = require('knox-mpu')
  , conf = require('./conf')
  , fs = require('fs');

function dumpStream (stream, filepath, cb) {
  // console.log(filepath);

  var client = knox.createClient(conf.aws());

  var upload = new MultiPartUpload(
      {
          client: client,
          objectName: filepath, // Amazon S3 object name
          stream: stream,
          noDisk: true,
          headers: {'x-amz-acl': 'private', 'Content-Type' :'binary/octet-stream' },
          // partSize: 800000,
          agent: false
      }, cb
  );

  upload.on('initiated', function () {
    // console.log('initiated ', arguments);
  });

  upload.on('uploading', function () {
    // console.log('uploading ', arguments);
  });

  upload.on('error', function () {
    // console.log('error ', arguments);
  });

  upload.on('completed', function () {
    // console.log('completed ', arguments);
  });

  upload.on('failed', function () {
    // console.log('failed ', arguments);
  });

}

module.exports.dump = dumpStream;