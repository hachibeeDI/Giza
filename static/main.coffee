'use strict'

END = null

myapp = angular.module('withjinja', [])
# solve conflict between Jinja2 and AngularJs
myapp.config ($interpolateProvider) ->
  $interpolateProvider.startSymbol '[['
  $interpolateProvider.endSymbol ']]'

myapp.controller('EntryController', ['$scope'
  ($scope) ->
    $scope.entry_id = ''
    $scope.chose_id = (entry_id) ->
      $scope.entry_id = entry_id
    END
  ]
)

