do (app=angular.module "sortirDeParis.home", [
  'ui.router'
  'sortirDeParis.fields'
  'sortirDeParis.fieldDetail'
  'sortirDeParis.home.resource'
]) ->
  app.config ($stateProvider) ->
    $stateProvider.state 'home',
      url: '/'
      abstract: true
      views:
        "main":
          controller: 'HomeController'
          templateUrl: 'home/home.tpl.html'

  app.controller 'HomeController', [
    '$scope', '$mdBottomSheet', '$state',
    ($scope, $mdBottomSheet, $state) ->
      $scope.$state = $state
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

  app.filter 'timeFilter', ()->
    (total_seconds)->
      seconds = total_seconds % 60
      minutes = (( total_seconds - seconds ) / 60) % 60
      hours = (total_seconds - ( total_seconds % 3600 )) / 3600
      if minutes < 10
        minutes = '0' + minutes
      hours + 'h' + minutes

  app.filter 'frenchNumber', ()->
    (string)->
      string.replace /,/g, ' '

