'use strict'

class Project
  constructor: (id, name, files) ->
    @id = id
    @name = name
    @files = files


# 全体的にエラー時の処理がない感じのアレなので後でどうにかする
@myapp.service('projectService',
  ($http) ->
    @build = (id) ->
      if not(id == 0 or id) then return 'error'
      $http
        method: 'GET'
        url: '/build/' + id  # urljoinみたいなのある？
        params: {}
      .success (data, status, headers, config) ->
        return data
      .error (data, status, headers, config) ->
        return data

    @get_project = (id) ->
      $http
          method: 'GET'
          url: '/entry/' + id
          params: {}
        .success (data, status, headers, config) ->
          new Project(data.id, data.name, data.files)
        .error (data, status, headers, config) ->
          alert('error!')
          console.log data
          data

    @get_content = (id, filepath) ->
      $http.post(
        '/entry/' + id,
        {'filepath': filepath}
      )
      .success (data, status, headers, config) ->
        return data.content
      .error (data, status, headers, config) ->
        alert('error!')

    return
)
