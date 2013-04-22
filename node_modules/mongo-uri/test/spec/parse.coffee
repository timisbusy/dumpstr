MongoUri = require "#{LIB_ROOT}/mongo-uri"

describe "parse", ->
  it "should throw type error when missing uri portion", ->
    fn = ->
      MongoUri.parse()
    expect(fn).to.throw TypeError, /must be a string/

  it "should throw type error when not mongodb: scheme", ->
    fn = ->
      MongoUri.parse("http://test.com")
    expect(fn).to.throw TypeError, /must be mongodb scheme/

  it "should parse a simple username and password", ->
    uri = MongoUri.parse "mongodb://user:password@localhost/test"
    expect(uri.username).to.equal "user"
    expect(uri.password).to.equal "password"

  it "should parse uri encoded username and password", ->
    uri = MongoUri.parse "mongodb://%40u%2Fs%3Fe%3Ar:p%40a%2Fs%3Fs%3A@localhost"
    expect(uri.username).to.equal "@u/s?e:r"
    expect(uri.password).to.equal "p@a/s?s:"

  it "should parse a simple hostname and null port without auth", ->
    uri = MongoUri.parse "mongodb://thehostname"
    expect(uri.hosts).to.have.length 1
    expect(uri.ports).to.have.length 1
    expect(uri.hosts[0]).to.equal "thehostname"
    expect(uri.ports[0]).to.equal null

  it "should parse a set of hostnames", ->
    uri = MongoUri.parse "mongodb://host1,host2,host3:3,host4:4/path?w=1"
    expect(uri.hosts).to.have.length 4
    expect(uri.ports).to.have.length 4
    expect(uri.hosts).to.eql ["host1", "host2", "host3", "host4"]
    expect(uri.ports).to.eql [null, null, 3, 4]

  it "should parse hostnames with auth and path", ->
    uri = MongoUri.parse "mongodb://user:pass@host1:1,host2:2,host3/selected-database?w=1"
    expect(uri.hosts).to.eql ["host1", "host2", "host3"]
    expect(uri.ports).to.eql [1, 2, null]

  it "should parse null for database when unspecified", ->
    uri = MongoUri.parse "mongodb://host"
    expect(uri.database).to.equal null

  it "should parse the database when it is the last part of the uri", ->
    uri = MongoUri.parse "mongodb://user:pass@host1,host2/db"
    expect(uri.database).to.equal "db"

  it "should parse the database when there are options afterwards", ->
    uri = MongoUri.parse "mongodb://host/db?w=1&test=hi"
    expect(uri.database).to.equal "db"

  it "should specify null when database is empty string", ->
    uri = MongoUri.parse "mongodb://host/?options"
    expect(uri.database).to.equal null

  it "should parse querystring with no options", ->
    uri = MongoUri.parse "mongodb://host/?"
    expect(uri.options).to.eql {}

  it "should parse querystring with single option", ->
    uri = MongoUri.parse "mongodb://host/?w=1"
    expect(uri.options).to.eql {w:"1"}

  it "should parse querystring with multiple of the same value", ->
    uri = MongoUri.parse "mongodb://host/?readPreferenceTags=dc:ny,rack:1&readPreferenceTags=dc:ny&readPreferenceTags="
    expect(uri.options).to.eql {readPreferenceTags: ["dc:ny,rack:1", "dc:ny", ""]}

  it "should set empty string if an option is specified without a value", ->
    uri = MongoUri.parse "mongodb://host/?test"
    expect(uri.options).to.eql {test: ""}

  describe "mongodb examples", ->
    it "should parse localhost", ->
      uri = MongoUri.parse "mongodb://localhost"
      expect(uri.username).to.equal null
      expect(uri.password).to.equal null
      expect(uri.hosts).to.eql ["localhost"]
      expect(uri.ports).to.eql [null]
      expect(uri.database).to.eql null
      expect(uri.options).to.eql {}

    it "should parse localhost with user and password", ->
      uri = MongoUri.parse "mongodb://sysop:moon@localhost"
      expect(uri.username).to.equal "sysop"
      expect(uri.password).to.equal "moon"
      expect(uri.hosts).to.eql ["localhost"]
      expect(uri.ports).to.eql [null]
      expect(uri.database).to.eql null
      expect(uri.options).to.eql {}

    it "should parse with database", ->
      uri = MongoUri.parse "mongodb://sysop:moon@localhost/records"
      expect(uri.username).to.equal "sysop"
      expect(uri.password).to.equal "moon"
      expect(uri.hosts).to.eql ["localhost"]
      expect(uri.ports).to.eql [null]
      expect(uri.database).to.eql "records"
      expect(uri.options).to.eql {}

    it "shouldn't parse a unix domain socket", ->
      fn = ->
        uri = MongoUri.parse "mongodb:///tmp/mongodb-27017.sock"
      expect(fn).to.throw TypeError, /uri must specify hostname/

    it "should parse a replica set with two members", ->
      uri = MongoUri.parse "mongodb://db1.example.net,db2.example.com"
      expect(uri.username).to.equal null
      expect(uri.password).to.equal null
      expect(uri.hosts).to.eql ["db1.example.net", "db2.example.com"]
      expect(uri.ports).to.eql [null, null]
      expect(uri.database).to.eql null
      expect(uri.options).to.eql {}

    it "should parse a replica set with three members and varous ports", ->
      uri = MongoUri.parse "mongodb://localhost,localhost:27018,localhost:27019"
      expect(uri.username).to.equal null
      expect(uri.password).to.equal null
      expect(uri.hosts).to.eql ["localhost", "localhost", "localhost"]
      expect(uri.ports).to.eql [null, 27018, 27019]
      expect(uri.database).to.eql null
      expect(uri.options).to.eql {}

    it "should parse a replica set with three members and distributes read preferences", ->
      uri = MongoUri.parse "mongodb://example1.com,example2.com,example3.com/?readPreference=secondary"
      expect(uri.username).to.equal null
      expect(uri.password).to.equal null
      expect(uri.hosts).to.eql ["example1.com", "example2.com", "example3.com"]
      expect(uri.ports).to.eql [null, null, null]
      expect(uri.database).to.eql null
      expect(uri.options).to.eql {readPreference: "secondary"}

    it "should parse a replica set with write concern specified", ->
      uri = MongoUri.parse "mongodb://example1.com,example2.com,example3.com/?w=2&wtimeoutMS=2000"
      expect(uri.username).to.equal null
      expect(uri.password).to.equal null
      expect(uri.hosts).to.eql ["example1.com", "example2.com", "example3.com"]
      expect(uri.ports).to.eql [null, null, null]
      expect(uri.database).to.eql null
      expect(uri.options).to.eql {w: "2", wtimeoutMS: "2000"}
