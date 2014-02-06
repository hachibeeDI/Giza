
myapp.controller('EditorCtrl',
  ($scope, $http, currentEditingTarget) ->
    $scope.editingFile = currentEditingTarget
    $scope.saved = false


    @cancel = () ->
      $scope.editingFile.headingMessage = ''
      $scope.editingFile.detailsMessage = ''

    @save = () ->
      # aceのオブザーバーにセットしたほうが良いかな？
      $scope.editingFile.content = Grobal.$editor.getSession().getValue()
      $scope.editingFile
        .save()
        .then (result) ->
          console.dir result

    @show_save_message = () ->
      console.log "----- clicked  #{$scope.saved} ------------------"
      $scope.saved = true

    @hide_save_message = () ->
      console.log "----- clicked  #{$scope.saved} ------------------"
      $scope.saved = false

    END

)
