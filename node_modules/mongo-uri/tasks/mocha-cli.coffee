##
# I like the name of mocha-cli, but the current grunt-mocha-cli is just a pile
# of unworthy shit. I'll send some pull requests his way... but for now, I just
# need to get things done.

fs = require "fs"
path = require "path"
{spawn} = require "child_process"

module.exports = (grunt)->
  grunt.registerTask "mochacli", "runs my tests the way I want and is not configurable", ->
    done = @async()
    args = [
      "--colors"
      "--recursive"
      "--compilers"
      "coffee:coffee-script"
      "--reporter"
      "spec"
      "--require"
      "test/common.js"
      "test"
    ]
    bin = path.resolve "node_modules/.bin/mocha"
    fs.exists bin, (exists)->
      grunt.fatal "must install mocha as a project dependency", 1 unless exists

      mocha = spawn bin, args
      mocha.stdout.pipe process.stdout
      mocha.stderr.pipe process.stderr
      mocha.on "exit", (code)->
        return grunt.fatal "mocha returned error code: #{code}", 1 if code
        done()
