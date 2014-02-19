module.exports = (grunt)->
  'use strict'
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    watch:
      files: [
        'static/coffee/*.coffee'
        'static/coffee/*/*.coffee'
        'static/stylus/*.styl'
        'test/spec/*.coffee'
      ]
      tasks: ['coffee', 'stylus']

    coffee:
      compile:
        options:
          bare: true
          sourceMap: true,
          sourceMapDir: 'static/'
        files: [
          'static/app.js': [
            'static/coffee/app.coffee'
            'static/coffee/controllers/*.coffee'
            'static/coffee/services/*.coffee'
            'static/coffee/directives/*.coffee'
            'static/coffee/filters/*.coffee'
          ]
          'test/spec/BaseSpec.js': 'test/spec/*.coffee'
        ]

    stylus:
      compile:
        options:
          paths: ['/usr/local/lib/node_modules/nib/lib/']
        files:
          'static/main.css': 'static/stylus/main.styl'
          'static/genericons.css': 'static/stylus/genericons.styl'

    karma:
      unit:
        configFile: 'karma.conf.js'
      tasks: ['coffee']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-karma'
  grunt.registerTask 'default', ['watch']
  return
