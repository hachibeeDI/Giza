
myapp.controller('EditorCtrl',
  ($scope, $http, $timeout, currentEditingTarget) ->
    $scope.editingFile = currentEditingTarget
    $scope.saving = false


    @cancel = () ->
      $scope.editingFile.clear_commitment()

    @save = () ->
      # aceのオブザーバーにセットしたほうが良いかな？
      $scope.editingFile.content = Grobal.$editor.getSession().getValue()
      $scope.editingFile
        .save()
        .then (result) =>
          console.dir result
          @show_save_message()

    @show_save_message = () ->
      $scope.saving = true
      $timeout () ->
        $scope.saving = false
      , 3000

    END

)
