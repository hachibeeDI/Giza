'use strict'

END = null

myapp = angular.module('withjinja', [])
# solve conflict between Jinja2 and AngularJs
myapp.config ($interpolateProvider) ->
  $interpolateProvider.startSymbol '[['
  $interpolateProvider.endSymbol ']]'

myapp.controller('EntryController', ['$scope', '$http'
  ($scope, $http) ->
    $scope.entry_id = ''
    $scope.build_result = ''

    $scope.chose_id = (entry_id) ->
      $scope.entry_id = entry_id

    $scope.do_build = () ->
      if $scope.entry_id == ''
        return
      $http
        method: 'GET'
        url: '/build/' + $scope.entry_id  # urljoinみたいなのある？
        params: {}
      .success (data, status, headers, config) ->
        $scope.build_result = data
      .error (data, status, headers, config) ->
        $scope.build_result = data
    END
  ]
)

