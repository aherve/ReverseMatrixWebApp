do (app=angular.module "sortirDeParis", [
  'sortirDeParis.home',

  'uiGmapgoogle-maps',
  'ngMaterial',

  'sortirDeParis.fieldDetail',
  'sortirDeParis.list',
  'sortirDeParis.map',
  'sortirDeParis.fields',
  'templates-app',
  'templates-common',
  'ui.router.state',
  'ui.router',
]) ->

  app.config ($stateProvider, $urlRouterProvider) ->

  app.run ->

  app.controller 'AppController', ($scope) ->

  app.config ([
    '$mdThemingProvider',
    ($mdThemingProvider)->
      $mdThemingProvider.setDefaultTheme('deep-purple')
  ])

  app.directive 'ionRangeSlider', ()->
    restrict: 'A'
    scope:
      rangeOptions: '='
    link: (scope, elem, attrs) ->
      elem.ionRangeSlider(scope.rangeOptions)

  # Configuration block for Restangular, the service
  # used to communicate with the api
  app.config [
    "RestangularProvider"
    (RestangularProvider) ->
      toType = (obj) ->
        ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()

      RestangularProvider
        .setBaseUrl("/api/")
        .setRequestSuffix("/?format=json").setDefaultHttpFields
          withCredentials: true
          cache: false
        .setDefaultHeaders "Content-Type": "application/json"
        .setFullRequestInterceptor
        (element, operation, route, url, headers, params, httpConfig) ->
          headers["content-type"] = "application/json"

          # find arrays in requests and transform 'key' into 'key[]'
          # so that rails can understand that the reuquets contains
          #an array
          angular.forEach params, (param, key) ->
            if toType(param) is "array"
              newParam = []
              angular.forEach param, (value, key) ->
                newParam[key] = value
                return

              params[key + "[]"] = newParam
              delete params[key]

              newParam = null
            return

          element: element
          params: params
          headers: headers
          httpConfig: httpConfig
  ]
