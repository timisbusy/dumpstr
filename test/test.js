var dumpstr = require('..');
var datestr = +new Date();
var conf = require('./conf');
dumpstr.setLogLevel(1);
dumpstr.dump(conf.uri, "test-" + datestr, { partSize: 2*10485760 }, function (err, res) {
  console.log(arguments);
});
