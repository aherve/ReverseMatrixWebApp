do (app=angular.module "sortirDeParis", [
  'uiGmapgoogle-maps',
  'ngMaterial',
  'templates-app',
  'templates-common',
  'ui.router.state',
  'ui.router',
  'restangular',
]) ->

  app.factory 'Loading', [
    '$timeout',
    ($timeout)->
      new class Loading
        constructor: ->
          @loading = false

        start: ->
          @loading = true
          that = @
          $timeout(
            ()->
              that.loading = false
            1000
          )

        end: ->
          @loading = false
  ]

  app.controller 'FiltersController', [
    '$scope', '$mdDialog', 'Loading',
    ($scope, $mdDialog, Loading)->

      $scope.hide = ()->
        Loading.start()
        $mdDialog.hide()

      $scope.cancel = ()->
        $mdDialog.cancel()
  ]

  app.controller 'AppController', [
    '$scope', '$mdSidenav', '$mdDialog', 'Loading',
    ($scope, $mdSidenav, $mdDialog, Loading) ->
      $scope.Loading = Loading
      $scope.data =
        selectedIndex: 0

      $scope.options =
        type: "single"
        min: 5
        max: 595
        from: $scope.value
        prettify: (num)->
          inf = num - 5
          sup = num + 5
          prettify(inf) + " - " + prettify(sup)
        step: 10
        onFinish: (obj) ->
          changeRange( obj.from, obj.to )

      $scope.showFilters = ( event )->
        $mdDialog.show
          templateUrl: 'filters.tpl.html'
          controller: 'FiltersController'
          targetEvent: event


      $scope.markerClick = ()->
        $scope.toggleRight()

      $scope.itemClick = ()->
        $scope.toggleRight()

      $scope.toggleRight = ()->
        $mdSidenav('right').toggle()

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
