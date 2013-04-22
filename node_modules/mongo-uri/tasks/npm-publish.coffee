fs = require "fs"
path = require "path"
{spawn} = require "child_process"

module.exports = (grunt)->
  grunt.registerTask "npm-publish", "runs npm publish for me as a grunt task", ->
    done = @async()
    args = ["npm", "publish"]
    bin = path.resolve "/usr/bin/env"
    npm = spawn bin, args
    npm.stdout.pipe process.stdout
    npm.stderr.pipe process.stderr
    npm.on "exit", (code)->
      return grunt.fatal "npm error code: #{code}", 1 if code
      done()
