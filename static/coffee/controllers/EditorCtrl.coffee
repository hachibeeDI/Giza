
myapp.controller('EditorCtrl',
  ($scope, $http, currentEditingTarget) ->
    $scope.editingFile = currentEditingTarget

    @cancel = () ->
      $scope.editingFile.headingMessage = ''
      $scope.editingFile.detailsMessage = ''

    @save = () ->

    END
)
