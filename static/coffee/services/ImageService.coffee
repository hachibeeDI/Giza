myapp.service 'imageService',
  ($http) ->
    save_image: (id, image_form) ->
      $http.post(
        "/entry/#{id}/image"
        image_name: image_form.name, content: image_form.content
      )
        .then (result) ->
          result.data
        , (result) ->
          alert('error!'+result)
