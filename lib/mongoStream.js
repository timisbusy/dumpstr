var spawn = require("child_process").spawn;

function getStream (uriInfo, collectionName, cb) {
  var args = createDumpArgs(uriInfo, collectionName);
  // console.log(args);

  // var spawnedString = "mongodump";

  // args.forEach(function (arg) {
  //   spawnedString += " " + arg;
  // });

  // console.log(spawnedString);

  var dumpChild = spawn("mongodump", args);
  
  // TODO: What todo here?

  dumpChild.on('error', function (err) {
    // console.error(err);
  });


  dumpChild.on('exit', function () {
    // console.log('exited');
    // console.log(arguments);
  });

  dumpChild.on('close', function () {
    // console.log('closed');
    // console.log(arguments);
  });

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