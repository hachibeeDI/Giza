'use strict'

Grobal = window
END = null

@myapp = angular.module('withjinja', ['ngAnimate', 'ui.ace'])
# solve conflict between Jinja2 and AngularJs
myapp.config ($interpolateProvider) ->
