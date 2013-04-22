var confPath = process.cwd() + "/" + "conf.js"
  , confSet = false
  , awsCreds;

function setConfig (path) {
  confSet = true;
  confPath = path;
}

function aws () {
  if (confSet) { return require(confPath).aws; }
  if (process.env.AWS_KEY && process.env.AWS_SECRET && process.env.AWS_BUCKET) {
    return { 
      key: process.env.AWS_KEY
    , secret: process.env.AWS_SECRET
    , bucket: process.env.AWS_BUCKET
    };
  }
  return require(confPath).aws;
}

module.exports = {
  aws: aws
  , setConfig: setConfig
};