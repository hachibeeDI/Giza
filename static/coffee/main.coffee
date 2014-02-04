'use strict'

END = null

@myapp = angular.module('withjinja', [])
# solve conflict between Jinja2 and AngularJs
myapp.config ($interpolateProvider) ->
  $interpolateProvider.startSymbol '[['
  $interpolateProvider.endSymbol ']]'

myapp.controller('EntryController',
  ($scope, $http, projectService) ->
    $scope.entry_id = ''
    $scope.entry_name = ''
    $scope.build_result = ''

    $scope.chose_id = (entry_id, entry_name) ->
      '''
      get entry informations
      '''
      if not(entry_id == 0 or entry_id) then return

      project = projectService.get_project(entry_id)
      project.then (result) ->
        data = result.data
        $scope.entry_id = data.id
        $scope.entry_name = data.name

        file_holder = document.getElementById 'project_files'
        file_holder.innerHTML = ''
        for content in data.files
          child = document.createElement('li')
          child.innerText = content
          file_holder.appendChild(child)
        END


    $scope.do_build = () ->
      if angular.isNumber $scope.entry_id then return
      $scope.build_result = projectService.build($scope.entry_id)


    $scope.show_content = () ->
      projectService.get_content('0', 'sample/source/conf.py')
        .then((result) -> 
          $editor.getSession().setValue(result.data.content)
        )

    END
)

