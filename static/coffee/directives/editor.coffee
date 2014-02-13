# via: http://qiita.com/grapswiz@github/items/878432cb7e04039b06fb

myapp.directive('aceEditor', (currentEditingTarget) ->
  return {
    templateUrl: 'static/templates/aceEditor.html'
    replace: true
    restrict: 'E'
    scope:
      target_file: '=targetFile'
    link: (scope, element) ->
      Grobal.$editor = ace.edit("editor")
      _$editor = Grobal.$editor
      _$editor.setTheme("ace/theme/monokai")
      # 80文字の目印ラインを消す
      _$editor.setShowPrintMargin(false)
      scope.$watch('target_file', (new_file, oldVar) ->
        if not new_file then return
        if not new_file.file_path then return

        _filename = new_file.file_path
        if _filename.match(/\.py$/)
          _$editor.getSession().setMode('ace/mode/python')
        else if _filename.match(/\.rst$/)
          _$editor.getSession().setMode('ace/mode/markdown')
        else
          _$editor.getSession.setMode('ace/mode/markdown')

        _$editor.setValue(new_file.content)
        _$editor.clearSelection()
      , true
      )
  }
)
