var dumpstr = require('..');
dumpstr.dump("mongodb://localhost/gochime", "testing", function (err, res) {
  console.log(arguments);
});