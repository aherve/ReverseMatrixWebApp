do (app=angular.module "sortirDeParis.fieldDetail", [
  'ui.router'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'home.fieldDetail',
      url: 'field/:fieldId'
      views:
        "main":
          controller: 'FieldDetailController'
          templateUrl: 'home/fieldDetail/fieldDetail.tpl.html'
      data:
        pageTitle: 'détail'
  ]

  app.controller 'FieldDetailController', [
    '$scope', '$window',
    ($scope, $window) ->
      $scope.back = ()->
        $window.history.back()

      $scope.map =
        control: {}
        center:
          latitude: 8
          longitude: -73
        zoom: 8

      $scope.cities = [
        id: 1
        latitude: 8
        longitude: -73
      ]
  ]
