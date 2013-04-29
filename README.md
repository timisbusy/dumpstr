# dumpstr

A node.js package to dump mongodb (mongodump) directly into s3 without filling up your local disk in the process.

NOTE: This is still a work in progress. Please don't rely on it as your only backup option, especially without some decent testing.

## Install

    npm install dumpstr

## Use

    var dump = require('dumpstr').dump;

    var now = +new Date(); // gives the current time as a number

    dump("MY_MONGO_URI", "mongobackup-" + now, function (err, res) {
      if (err) { throw err; }
      console.log('results: ', res);
    });

By default, dumpstr will check for a file in your working directory called "conf.js", which should look something like this. 
    // This file is called conf.js
    module.exports = {
      aws: {
        key: "MY_KEY_IS_HERE"
      , secret: "THIS_IS_SECRET_HERE"
      , bucket: "I_HAS_A_BUCKET"
      }
    }

You can also update that path using setConfig.

    var md = require('dumpstr')
    , dump = md.dump;
    
    md.setConfig("my_config_path/is_better.js");

If you want to keep your configs in environment variables instead (Who could blame you?), go ahead and set these instead. That way you can leave out the config file entirely.

    AWS_KEY
    AWS_SECRET
    AWS_BUCKET