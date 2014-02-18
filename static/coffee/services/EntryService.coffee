'use strict'

class Project
  constructor: (id, name, files, conf) ->
    @id = id
    @name = name
    @files = files
    @conf = conf
  get_files_as_tree: () =>
    root = {}
    paths_each_dir = @files.map((file) -> file.split('/').filter((file) -> file != ''))
    for path_each_dir in paths_each_dir
      first_node_name = path_each_dir.shift()
      if first_node_name not of root
        root[first_node_name] = {}
      node = root[first_node_name]
      while path_each_dir.length > 0
        node_name = path_each_dir.shift()
        is_last_element = path_each_dir.length == 0
        if is_last_element
          node[node_name] = node_name
        else if node_name not of node
          node[node_name] = {}
        node = node[node_name]
    return root


myapp.factory('currentEditingTarget', ($http) ->
  id: null
  file_path: ''
  content: ''
  headingMessage: ''
  detailsMessage: ''
  set_project: (proj, content) ->
    @id = proj.id
    @name = proj.name
    @content = content
    @clear_commitment()
  save: () ->
    if not (@file_path and @content)
      throw "invalid arguments: file_path = #{@file_path}, content = #{@content}"
    $http.post(
      '/entry/content/' + @id
      {
        file_path: @file_path
        content: @content
      }
    )

  clear_commitment: () ->
    @headingMessage = ''
    @detailsMessage = ''
)


# 全体的にエラー時の処理がない感じのアレなので後でどうにかする
myapp.service('projectService',
  ($http) ->
    @build = (id) ->
      if not(id == 0 or id) then return 'error'
      $http.get("/build/#{id}")
        .then (data, status, headers, config) ->
          return data
        , (data, status, headers, config) ->
          console.log "build failed => #{data}"
          return data

    @get_projects = (limit=0) ->
      $http.get('/entries')
        .then (result) ->
          data = result.data
          if limit == 0
            (new Project(proj.id, proj.name, proj.files, proj.conf) for proj in data.entries)
          else
            (
              new Project(proj.id, proj.name, proj.files, proj.conf) for proj in data.entries
            )[0..limit]

        , (result) ->
          alert('error!')
          result

    @get_project = (id) ->
      $http.get("/entry/#{id}")
        .then (result) ->
          data = result.data
          new Project(data.id, data.name, data.files, data.conf)
        , (result) ->
          data = result.data
          alert('error!')
          console.log data
          data

    @get_content = (id, file_path) ->
      $http.post(
        '/entry/' + id,
        {file_path: file_path}
      )
      .success (data, status, headers, config) ->
        return data.content
      .error (data, status, headers, config) ->
        alert('error!')

    return
)
