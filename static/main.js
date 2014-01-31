// Generated by CoffeeScript 1.6.3
(function() {
  'use strict';
  var END, myapp;

  END = null;

  myapp = angular.module('withjinja', []);

  myapp.config(function($interpolateProvider) {
    $interpolateProvider.startSymbol('[[');
    return $interpolateProvider.endSymbol(']]');
  });

  myapp.controller('EntryController', [
    '$scope', '$http', function($scope, $http) {
      $scope.entry_id = '';
      $scope.build_result = '';
      $scope.chose_id = function(entry_id) {
        return $scope.entry_id = entry_id;
      };
      $scope.do_build = function() {
        if ($scope.entry_id === '') {
          return;
        }
        return $http({
          method: 'GET',
          url: '/build/' + $scope.entry_id,
          params: {}
        }).success(function(data, status, headers, config) {
          return $scope.build_result = data;
        }).error(function(data, status, headers, config) {
          return $scope.build_result = data;
        });
      };
      return END;
    }
  ]);

}).call(this);