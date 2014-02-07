module.exports = (grunt)->
  'use strict'
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    watch:
      files: [
        'static/coffee/*.coffee'
        'static/coffee/*/*.coffee'
        'static/stylus/*.styl'
      ]
      tasks: ['coffee', 'stylus']

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

    stylus:
      compile:
        options:
          paths: ['/usr/local/lib/node_modules/nib/lib/']
        files:
          'static/main.css': 'static/stylus/main.styl'
          'static/genericons.css': 'static/stylus/genericons.styl'


  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.registerTask 'default', ['watch']
  return
