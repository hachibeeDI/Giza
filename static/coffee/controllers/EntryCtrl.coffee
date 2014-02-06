
END = null

myapp.controller('EntryCtrl',
  ($scope, $http, projectService, currentEditingTarget) ->
    $scope.current_project = null
    $scope.build_result = ''
    $scope.selected_file = currentEditingTarget

    @chose_id = (entry_id) ->
      '''
      get entry informations
      TODO: cache function
      '''
      if not(entry_id == 0 or entry_id) then return

      project = projectService.get_project(entry_id)
      project.then (result) ->
        data = result.data
        $scope.current_project = data


    @do_build = () ->
      if angular.isNumber $scope.entry_id then return
      $scope.build_result = projectService.build($scope.entry_id)


    @show_content = (id, file_path) ->
      projectService.get_content(id, file_path)
        .then((result) ->
          $scope.selected_file.id = id
          $scope.selected_file.name = result.data.filepath.toString()
          $scope.selected_file.content = result.data.content
        )

    END
)

