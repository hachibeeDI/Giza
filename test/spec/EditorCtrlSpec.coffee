describe "EditorCtrl", () ->
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
    $injector, currentEditingTarget
  ) ->
    scope = $rootScope.$new()
    http = $http
    location = $location
    timeout = $timeout
    service = $injector.get 'currentEditingTarget'
    $httpBackend = _$httpBackend_
    controller = $controller('EditorCtrl',
      $scope: scope
      $http: http
      $timeout: timeout
      currentEditingTarget: service
    )
  beforeEach ->
    $httpBackend.whenPOST(/\/entry\/content\/\d+/)
      .respond({})  # 必要になったら中身を作る

  it 'should initialized', () ->
    expect(scope.editingFile.file_path).toEqual('')

  it 'cancel behavior', () ->
    scope.editingFile.headingMessage = 'heading'
    scope.editingFile.detailsMessage = 'details'
    controller.cancel()
    expect(scope.editingFile.headingMessage).toEqual ''
    expect(scope.editingFile.detailsMessage).toEqual ''

  it 'should true when saving',  ->
    expect(scope.saving).toBe(false)
    scope.editingFile.id = 0
    scope.editingFile.file_path = 'dummy'
    scope.editingFile.content = 'nor'
    controller.save()
    $httpBackend.flush()
    expect(scope.saving).toBe(true)
