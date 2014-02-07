
myapp.controller('EditorCtrl',
  ($scope, $http, $timeout, currentEditingTarget) ->
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
      $scope.saved = true
      $timeout () ->
        $scope.saved = false
      , 3000

    END

)
