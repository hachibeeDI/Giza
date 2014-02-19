myapp.controller('EntryCtrl',
  ($scope, $http, projectService, currentEditingTarget) ->
    $scope.current_project = null
    $scope.selected_file = currentEditingTarget
    #TODO: これはモデルにもっていく？
    projectService
      .get_projects()
      .then (result) ->
        $scope.whole_projects = result
    $scope.build_result = ''


    @chose_id = (entry_id) ->
      '''
      get entry informations
      TODO: cache function
      '''
      if not(entry_id == 0 or entry_id) then return

      projectService.get_project(entry_id)
        .then (result) ->
          $scope.current_project = result


    @do_build = () ->
      if not angular.isNumber $scope.current_project.id
        $scope.show_build_status = true
        $scope.build_result = '!! failed to build !!'
        return
      projectService.build($scope.current_project.id)
        .then (result) ->
          $scope.show_build_status = true
          $scope.build_result = result


    @show_content = (id, file_path) ->
      projectService.get_content(id, file_path)
        .then (result) ->
          $scope.selected_file.id = id
          $scope.selected_file.file_path = result.data.file_path.toString()
          $scope.selected_file.content = result.data.content

    @show_conf = (project) ->
      @show_content(project.id, project.conf)

    END
)

