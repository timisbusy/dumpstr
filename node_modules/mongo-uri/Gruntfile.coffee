module.exports = (grunt)->
  grunt.initConfig
    clean: ["lib"]
    coffee:
      glob:
        expand: true
        cwd: "src"
        src: ["*.litcoffee"]
        dest: "lib"
        ext: ".js"

  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadTasks "tasks"

  grunt.registerTask "test", ["clean", "coffee", "mochacli"]
  grunt.registerTask "publish", ["clean", "coffee", "npm-publish"]
