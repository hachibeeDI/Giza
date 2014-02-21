
myapp.controller('EditorCtrl',
  ($scope, $http, $timeout, currentEditingTarget, imageService) ->
    $scope.editingFile = currentEditingTarget
    $scope.saving = false
    $scope.image_form = {name: '', content: null}
    $scope.aceOption =
      useWrapMode : true
      showGutter: false
      theme:'solarized_light'
      mode: 'markdown'
      onLoad: (_ace) ->
        $scope.$watch 'editingFile.file_path', () ->
          _path = $scope.editingFile.file_path
          if not($scope.editingFIle and $scope.editingFile.file_path) then return
          _filename = switch
            when _path.match(/\.py$/) then 'python'
            when _path.match(/\.rst$/) then 'markdown'
            else 'markdown'
          _ace.getSession().setMode("ace/mode/#{_filename}")
        END


    @cancel = () ->
      $scope.editingFile.clear_commitment()

    @save = () ->
      $scope.editingFile
        .save()
        .then (result) =>
          @show_save_message()
      @show_save_message()

    @show_save_message = () ->
      $scope.saving = true
      $timeout () ->
        $scope.saving = false
      , 3000

    @save_image =  ->
      console.log $scope.editingFile
      imageService.save_image($scope.editingFile.id, $scope.image_form)
        .then (result) ->
          console.log result

    END

)
