module.exports = (grunt)->
  'use strict'
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    watch:
      files: ['static/coffee/*.coffee', 'static/coffee/*/*.coffee']
      tasks: 'coffee'

    coffee:
      compile:
        options:
          bare: true
        files: [
          'static/app.js': [
            'static/coffee/app.coffee'
            'static/coffee/controllers/*.coffee'
            'static/coffee/services/*.coffee'
            'static/coffee/directives/*.coffee'
            'static/coffee/filters/*.coffee'
          ]
        ]

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.registerTask 'default', ['watch']
  return
