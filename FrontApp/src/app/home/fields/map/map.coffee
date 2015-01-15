do (app=angular.module "sortirDeParis.map", [
  'ui.router'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'home.fields.map',
      url: 'map'
      views:
        "main":
          controller: 'MapController'
          templateUrl: 'home/fields/map/map.tpl.html'
      data:
        pageTitle: 'carte'
  ]

  app.controller 'MapController', [
    '$scope', '$state',
    ($scope, $state) ->
      $scope.$state = $state
      $scope.markerClick = (city)->
        console.log city
        $state.go 'home.fieldDetail', fieldId: city.key

  ]
