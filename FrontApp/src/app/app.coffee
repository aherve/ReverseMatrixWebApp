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

  app.factory 'FiltersService', [
    'Lands',
    (Lands)->
      new class FiltersService
        constructor: ->
          @time =
            from: 0
            to: 10000
          @surface =
            from: 20000
            to: 40000
          @includeArchived = false
          @includeInactive = false

        updateTime: (obj)->
          @time.from = obj.from
          @time.to = obj.to

        updateSurface: (obj)->
          @surface.from = obj.from
          @surface.to = obj.to

        fetchLands: ()->
          Lands.filter(@time.from, @time.to, @surface.from, @surface.to,
            @includeArchived - 1, @includeInactive - 1)
  ]

  app.controller 'FiltersController', [
    '$scope', '$filter', 'FiltersService', '$anchorScroll',
    ($scope, $filter, FiltersService, $anchorScroll)->

      $scope.FiltersService = FiltersService

      $scope.search = ()->
        content = angular.element(
          window.document.getElementById( 'global-content')
        )
        FiltersService.fetchLands().then ()->
          content.context.scrollTop = 0
          $scope.data.selectedIndex = 1

      $scope.timeOptions =
        type: "double"
        min: 0
        max: 28800
        from: FiltersService.time.from
        to: FiltersService.time.to
        prettify: (num)->
          h = (num - ( num % 3600 )) / 3600
          m = ((num - ( num % 60 )) / 60) % 60
          if m < 10 then m = '0' + m
          h + 'h' + m + 'min'
        drag_interval: true
        step: 600
        onFinish: (obj) ->
          FiltersService.updateTime(obj)

      $scope.surfaceOptions =
        type: "double"
        min: 0
        max: 100000
        from: FiltersService.surface.from
        to: FiltersService.surface.to
        prettify: (num)->
          $filter( 'number' )(num) + ' m2'
        drag_interval: true
        step: 2000
        onFinish: (obj) ->
          FiltersService.updateSurface(obj)
  ]

  app.controller 'LandController', [
    '$scope', 'Lands',
    ($scope, Lands)->
      $scope.Lands = Lands
  ]

  app.directive 'landContent', [
    ()->
      restrict: 'A'
      scope:
        land: '='
      templateUrl: 'land.tpl.html'
      controller: 'LandController'
  ]

  app.controller 'AppController', [
    '$scope', '$mdSidenav', '$mdDialog', 'Loading', 'Lands',
    ($scope, $mdSidenav, $mdDialog, Loading, Lands) ->
      $scope.Lands = Lands
      $scope.Loading = Loading
      $scope.data =
        selectedIndex: 0

      $scope.markerClick = ( land )->
        $scope.activeLand = land.model
        $scope.toggleRight()

      $scope.toggleRight = ()->
        $mdSidenav('right').toggle()

      $scope.map =
        control: {}
        center:
          latitude: 47.0833300
          longitude: 2.4
        zoom: 6
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

  app.filter 'replaceComa', [
    ()->
      (input)->
        input.replace /,/g, ' '
  ]

