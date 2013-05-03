var knox = require('knox')
  , MultiPartUpload = require('knox-mpu')
  , conf = require('./conf')
  , fs = require('fs')
  , log = require('loglevel');

function dumpStream (stream, filepath, options, cb) {
  // console.log(filepath);

  var client = knox.createClient(conf.aws());

  var upload = new MultiPartUpload(
      {
          client: client,
          objectName: filepath, // Amazon S3 object name
          stream: stream,
          noDisk: true,
          headers: {'x-amz-acl': 'private', 'Content-Type' :'binary/octet-stream' },
          partSize: options.partSize || 5242880,
          agent: false
      }, cb
  );

  upload.on('initiated', function () {
    log.debug('initiated ', arguments);
  });

  upload.on('uploading', function () {
    log.debug('uploading ', arguments);
  });

  upload.on('error', function () {
    log.warn('error ', arguments);
  });

  upload.on('completed', function () {
    log.info('completed ', arguments);
  });

  upload.on('failed', function () {
    log.error('failed ', arguments);
  });

}

module.exports.dump = dumpStream;