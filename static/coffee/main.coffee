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
    $scope.entry_name = ''
    $scope.build_result = ''

    $scope.chose_id = (entry_id, entry_name) ->
      '''
      get entry informations
      '''
      if not(entry_id == 0 or entry_id) then return

      $scope.entry_id = entry_id
      $scope.entry_name = entry_name
      $http
        method: 'GET'
        url: '/entry/' + $scope.entry_id  # urljoinみたいなのある？
        params: {}
      .success (data, status, headers, config) ->
        file_holder = document.getElementById 'project_files'
        file_holder.innerHTML = ''
        console.log data
        for content in data.target
          child = document.createElement('li')
          child.innerText = content
          file_holder.appendChild(child)
      .error (data, status, headers, config) ->
        alert('error!')
        console.log data
        #$scope.build_result = data

    $scope.do_build = () ->
      if angular.isNumber $scope.entry_id then return

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

