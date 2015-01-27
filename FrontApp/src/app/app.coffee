do (app=angular.module "trouverDesTerrains", [
  'ui.router',
  'ngMaterial'
  'trouverDesTerrains.main'
]) ->

  app.config ([
    '$mdThemingProvider',
    ($mdThemingProvider)->
      $mdThemingProvider.theme('default')
        .primaryColor('deep-purple')
        .accentColor('cyan')
        .warnColor('pink')
  ])

  app.config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.when '/', '/projets'
    $urlRouterProvider.otherwise '/projets'

  app.controller 'AppController', [
    '$scope', '$mdSidenav', '$state',
    ($scope, $mdSidenav, $state) ->
      $scope.$state = $state
      $scope.toggleLeftNav = ->
        $mdSidenav( 'sidenav-left' ).toggle()
  ]
