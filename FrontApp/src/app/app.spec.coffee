describe 'AppController', ->
  describe 'isCurrentUrl', ->
    AppCtrl = null

    beforeEach(module 'lumxTest')

    beforeEach(inject ($controller, _$location_, $rootScope) ->
      $location = _$location_
      $scope = $rootScope.$new()
      AppCtrl = $controller 'AppController',
        $location: $location
        $scope: $scope
    )

    it('should pass a dummy test', inject ->
      expect(AppCtrl).toBeTruthy()
    )
