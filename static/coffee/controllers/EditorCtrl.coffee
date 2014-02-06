
myapp.controller('EditorCtrl',
  ($scope, $http, currentEditingTarget) ->
    $scope.editingFile = currentEditingTarget


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

    END
)
