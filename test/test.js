var dumpstr = require('..');
var datestr = +new Date();
dumpstr.setLogLevel(1);
dumpstr.dump("mongodb://localhost/test", "test-" + datestr, { partSize: 2*10485760 }, function (err, res) {
  console.log(arguments);
});