# via: http://qiita.com/grapswiz@github/items/878432cb7e04039b06fb

myapp.directive('aceEditor', () ->
  return {
    templateUrl: 'static/templates/aceEditor.html'
    replace: true
    restrict: 'E'
    scope: true  # current_file だけ取り入れる方法がうまくいかねえ
    link: (scope, element) ->
      Grobal.$editor = ace.edit("editor")
      _$editor = Grobal.$editor
      _$editor.setTheme("ace/theme/monokai")
      scope.$watch('selected_file', (new_file, oldVar) ->
        if not new_file then return
        if not new_file.name then return

        _filename = new_file.name
        if _filename.match(/\.py$/)
          _$editor.getSession().setMode('ace/mode/python')
        else if _filename.match(/\.rst$/)
          _$editor.getSession().setMode('ace/mode/markdown')
        else
          _$editor.getSession.setMode('ace/mode/markdown')

        _$editor.setValue(new_file.content)

      , true
      )
  }
)
