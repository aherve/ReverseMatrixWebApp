do (app=angular.module "sortirDeParis", [
  'sortirDeParis.home',

  'lumx',
  'uiGmapgoogle-maps',

  'templates-app',
  'templates-common',
  'ui.router.state',
  'ui.router',
]) ->

  app.config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise '/home'

  app.run ->

  app.controller 'AppController', ($scope) ->

  app.directive 'ionRangeSlider', ()->
    restrict: 'A'
    scope:
      rangeOptions: '='
    link: (scope, elem, attrs) ->
      elem.ionRangeSlider(scope.rangeOptions)
