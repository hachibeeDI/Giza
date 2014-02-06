
myapp.directive('growlModal', ($timeout) ->
  return {
    templateUrl: 'static/templates/growlModal.html'
    replace: true
    restrict: 'E'
    transclude: true
    scope:
      'is_show': '=isShow'
    link: (scope, element, attrs, ctrl) ->
      scope.$watch('is_show', (now_var) ->
        console.log 'directive----------------'
        console.log scope.is_show
        console.log now_var
        console.log '----------------'
        if now_var == false
          element.addClass 'hidden-element'
          element.removeClass 'growl-modal'
          return

        $timeout(() ->
          element.removeClass 'hidden-element'
          element.addClass 'growl-modal'
          $timeout(() ->
            element.addClass 'hidden-element'
            element.removeClass 'growl-modal'
            scope.is_showed = false
          , 5000)
        )
      )
  }
)

