var spawn = require("child_process").spawn
  , log = require('loglevel');

function getStream (uriInfo, collectionName, cb) {
  var args = createDumpArgs(uriInfo, collectionName);
  // console.log(args);

  var spawnedString = "mongodump";

  args.forEach(function (arg) {
    spawnedString += " " + arg;
  });

  log.debug(spawnedString);

  var dumpChild = spawn("mongodump", args);
  
  // TODO: What todo here?

  dumpChild.on('error', function (err) {
    log.error(err);
  });


  dumpChild.on('exit', function () {
    log.info('exited');
  });

  dumpChild.on('close', function () {
    log.info('closed');
  });
  dumpChild.stdout.pause();
  cb(null, dumpChild.stdout);
}

function createDumpArgs (uriInfo, collection) {
  var host = uriInfo["ports"][0] ? uriInfo["hosts"][0] + ":" + uriInfo["ports"][0] : uriInfo["hosts"][0];
  var args = [];
  args.push('-h');
  args.push(host);
  if (uriInfo["username"]) {
    args.push('-u');
    args.push(uriInfo["username"]);
    args.push('-p');
    args.push(uriInfo["password"]);
  }
  args.push('-d');
  args.push(uriInfo["database"]);
  args.push('-c');
  args.push(collection);
  args.push('-o');
  args.push('-');
  return args;
}


module.exports = {
  getStream: getStream
}
