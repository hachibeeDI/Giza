
myapp.directive "fileread", [() ->
  return {
    scope:
      fileread: "="
    link: (scope, element, attributes) ->
      if not scope then scope.fileread = {name: '', content: null}

      element.bind "change", (changeEvent) ->
        reader = new FileReader()
        reader.onload = (loadEvent) ->
          scope.$apply ->
            scope.fileread.content = loadEvent.target.result
        # TODO: should I implement a size check?
        # read api has readAsBinaryString and readAsDataURL.
        # I have no idea about which is better. But BASE64 is easy to decode.
        f = changeEvent.target.files[0]
        reader.readAsDataURL f
        scope.fileread.name = f.name
  }
]
