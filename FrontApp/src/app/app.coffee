do (app=angular.module "sortirDeParis", [
  'uiGmapgoogle-maps',
  'ngMaterial',
  'templates-app',
  'templates-common',
  'ui.router.state',
  'ui.router',
  'sortirDeParis.resource'
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
            10000
          )

        stop: ->
          @loading = false
  ]

  app.controller 'FiltersController', [
    '$scope', '$mdDialog', 'Lands',
    ($scope, $mdDialog, Lands)->

      $scope.hide = ()->
        Lands.filter($scope.time.from, $scope.time.to,
          $scope.surface.from, $scope.surface.to)
        $mdDialog.hide()

      $scope.cancel = ()->
        $mdDialog.cancel()

      $scope.includeArchived = false
      $scope.includeInactive = false

      $scope.time =
        from: 0
        to: 10000

      $scope.surface =
        from: 0
        to: 200000

      $scope.timeOptions =
        type: "double"
        min: 0
        max: 28800
        from: $scope.time.from
        to: $scope.time.to
        prettify: (num)->
          h = (num - ( num % 3600 )) / 3600
          m = ((num - ( num % 60 )) / 60) % 60
          if m < 10 then m = '0' + m
          h + 'h' + m + 'min'
        drag_interval: true
        step: 600
        onFinish: (obj) ->

      $scope.surfaceOptions =
        type: "double"
        min: 0
        max: 1000000
        from: $scope.surface.from
        to: $scope.surface.to
        prettify: (num)->
          num + ' m2'
        drag_interval: true
        step: 2000
        onFinish: (obj) ->
  ]

  app.controller 'AppController', [
    '$scope', '$mdSidenav', '$mdDialog', 'Loading', 'Lands',
    ($scope, $mdSidenav, $mdDialog, Loading, Lands) ->
      $scope.Lands = Lands
      $scope.Loading = Loading
      $scope.data =
        selectedIndex: 0

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

  app.directive 'scrollClass', [
    '$timeout',
    ($timeout)->
      (scope, element, params)->
        $timeout(
          ()->
            container = angular.element( document.getElementById( 'content' ) )
            container.bind("scroll", (event)->
              if container.context.scrollTop >= 5
                element.addClass params.scrollClass
              else
                element.removeClass params.scrollClass
            )
        ,
          100
        )
  ]

