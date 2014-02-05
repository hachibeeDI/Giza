
END = null

myapp.controller('EntryCtrl',
  ($scope, $http, projectService) ->
    $scope.current_project = null
    $scope.build_result = ''

    $scope.chose_id = (entry_id) ->
      '''
      get entry informations
      TODO: cache function
      '''
      if not(entry_id == 0 or entry_id) then return

      project = projectService.get_project(entry_id)
      project.then (result) ->
        data = result.data
        $scope.current_project = data


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

