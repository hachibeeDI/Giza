describe "EntryCtrl", () ->
  exports = this
  scope = ''
  http = ''
  location = ''
  timeout = ''
  service = ''
  controller = ''
  $httpBackend = ''

  beforeEach angular.mock.module 'withjinja'

  beforeEach angular.mock.inject (
    $rootScope, $http
    $location, $timeout
    $controller
    _$httpBackend_
    $injector
  ) ->
    scope = $rootScope.$new()
    http = $http
    projectService = $injector.get 'projectService'
    currentEditingTarget = $injector.get 'currentEditingTarget'
    $httpBackend = _$httpBackend_
    controller = $controller('EntryCtrl',
      $scope: scope
      $http: http
      projectService: projectService
      currentEditingTarget: currentEditingTarget
    )

  beforeEach ->
    # called everytime when EntryCtrl initialized
    $httpBackend.expectGET('/entries')
      .respond __prepare_dummy_projects()


  __prepare_dummy_projects =  ->
    entry_datas = {
      entries: [
        {id: 0, name: 'test', files: ['a', 'b', 'c'], conf: 'source/conf.py'}
        {id: 1, name: 'test1', files: ['d', 'e', 'f'], conf: 'conf.py'}
      ]
    }
    return entry_datas

  _define_mock_for_chose_project =  ->
    $httpBackend.expectGET(/\/entry\/\d+/)
      .respond id: 100, name: 'test', files: ['d', 'e', 'f'], conf: 'conf.py'

  _define_mock_for_show_content =  ->
    $httpBackend.whenPOST(/\/entry\/\d+/)
      .respond id: 100, name: 'test', file_path: 'dummy.rst', content: 'moaaaaaaaaaaaa?'

  _define_mock_for_show_conf =  ->
    $httpBackend.whenPOST(/\/entry\/\d+/)
      .respond id: 100, name: 'test', file_path: 'conf.py', content: 'this is configure dummy'


  it 'should initialized', () ->
    expect(scope.current_project).toBe(null)

  it 'projects should be initialized', () ->
    $httpBackend.flush()
    expected_projects =
      (new Project(proj.id, proj.name, proj.files, proj.conf) for proj in __prepare_dummy_projects().entries)
    for expected, index in expected_projects
      targ = scope.whole_projects[index]
      expect(targ.equals(expected)).toBe(true)

  it 'should catch invalid build parameter',  ->
    expect(scope.current_project).toBe(null)
    controller.do_build()
    expect(scope.build_result).toBe('!! failed to build !!')

  it 'should failed when invalid id is selected',  ->
    expect(scope.current_project).toBe(null)
    controller.chose_id(null)
    expect(scope.current_project).toBe(null)

  it 'should indecate file when selected',  ->
    _define_mock_for_chose_project()

    expect(scope.selected_file.id).toBe(null)
    controller.chose_id(100)
    $httpBackend.flush()
    expect(scope.current_project.equals(
      new Project(100, 'test', ['d', 'e', 'f'], 'conf.py')
    )).toBe(true)

  it 'should indecate content when file selected',  ->
    _define_mock_for_show_content()
    controller.show_content(100, 'dummy.rst')
    $httpBackend.flush()
    expect(scope.selected_file.id).toEqual(100)
    expect(scope.selected_file.file_path).toEqual('dummy.rst')
    expect(scope.selected_file.content).toEqual('moaaaaaaaaaaaa?')

  it 'should indecate configure file when conf is selected',  ->
    _define_mock_for_show_conf()
    controller.show_conf(id: 100, conf: 'conf.py')
    $httpBackend.flush()
    expect(scope.selected_file.id).toEqual(100)
    expect(scope.selected_file.file_path).toEqual('conf.py')
    expect(scope.selected_file.content).toEqual('this is configure dummy')
