
myapp.filter('extractFilename', () ->
  return (input) ->
    return input.split('/').pop()
)
