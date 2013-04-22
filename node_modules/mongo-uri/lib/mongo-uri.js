(function() {
  var MongoUri, RE_PULL_DATABASE, RE_PULL_HOSTNAME_PORTION, RE_PULL_MONGODB_AUTH, RE_PULL_MONGODB_SCHEME, RE_PULL_OPTIONS, querystring;

  querystring = require("querystring");

  RE_PULL_MONGODB_SCHEME = /^mongodb:\/\/(.*)$/i;

  RE_PULL_MONGODB_AUTH = /^([^:\/\?,]+):([^@\/\?,]+)@(.*)$/;

  RE_PULL_HOSTNAME_PORTION = /^([^\/\?]+)(.*)$/;

  RE_PULL_DATABASE = /^\/([^?]*)($|\?.*$)/;

  RE_PULL_OPTIONS = /^\?(.*)$/;

  exports.MongoUri = MongoUri = (function() {

    function MongoUri() {
      this.username = null;
      this.password = null;
      this.hosts = null;
      this.ports = null;
      this.database = null;
      this.options = null;
    }

    return MongoUri;

  })();

  exports.parse = function(uri) {
    var mongoUri, _ref, _ref1, _ref2;
    if (typeof uri !== "string") {
      throw new TypeError("Parameter 'uri' must be a string, not " + (typeof uri));
    }
    mongoUri = new exports.MongoUri();
    uri = uri.trim();
    uri = exports._pullMongodbScheme(uri);
    _ref = exports._pullAuth(uri), mongoUri.username = _ref[0], mongoUri.password = _ref[1], uri = _ref[2];
    _ref1 = exports._pullHostnames(uri), mongoUri.hosts = _ref1[0], mongoUri.ports = _ref1[1], uri = _ref1[2];
    _ref2 = exports._pullDatabase(uri), mongoUri.database = _ref2[0], uri = _ref2[1];
    mongoUri.options = exports._pullOptions(uri)[0];
    return mongoUri;
  };

  exports._pullMongodbScheme = function(uri) {
    var matches;
    matches = uri.match(RE_PULL_MONGODB_SCHEME);
    if ((matches != null ? matches.length : void 0) !== 2) {
      throw new TypeError("uri must be mongodb scheme");
    }
    return matches[1];
  };

  exports._pullAuth = function(uri) {
    var matches, password, username;
    matches = uri.match(RE_PULL_MONGODB_AUTH);
    if (matches === null) {
      return [null, null, uri];
    }
    username = decodeURIComponent(matches[1]);
    password = decodeURIComponent(matches[2]);
    uri = matches[3];
    return [username, password, uri];
  };

  exports._pullHostnames = function(uri) {
    var host, hostname, hostnames, hosts, matches, port, ports, _i, _len, _ref;
    matches = uri.match(RE_PULL_HOSTNAME_PORTION);
    if ((matches != null ? matches.length : void 0) !== 3) {
      throw new TypeError("uri must specify hostname");
    }
    hostnames = matches[1].split(",");
    uri = matches[2];
    hosts = [];
    ports = [];
    for (_i = 0, _len = hostnames.length; _i < _len; _i++) {
      hostname = hostnames[_i];
      if (hostname.indexOf(":") === -1) {
        port = null;
        host = hostname;
      } else {
        _ref = hostname.split(":"), host = _ref[0], port = _ref[1];
        port = parseInt(port, 10);
      }
      hosts.push(host);
      ports.push(port);
    }
    return [hosts, ports, uri];
  };

  exports._pullDatabase = function(uri) {
    var database, matches;
    matches = uri.match(RE_PULL_DATABASE);
    if (matches === null) {
      return [null, uri];
    }
    database = matches[1];
    uri = matches[2];
    database = database.length ? database : null;
    return [database, uri];
  };

  exports._pullOptions = function(uri) {
    var matches, options;
    matches = uri.match(RE_PULL_OPTIONS);
    if (matches === null) {
      return [Object.create(null)];
    }
    options = querystring.parse(matches[1]);
    return [options];
  };

}).call(this);
