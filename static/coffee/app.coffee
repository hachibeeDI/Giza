'use strict'

@myapp = angular.module('withjinja', [])
# solve conflict between Jinja2 and AngularJs
myapp.config ($interpolateProvider) ->
  $interpolateProvider.startSymbol '[['
  $interpolateProvider.endSymbol ']]'
