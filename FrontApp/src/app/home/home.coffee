###
# Each section of the site has its own module. It probably also has
# submodules, though this boilerplate is too simple to demonstrate it. Within
# 'src/app/home', however, could exist several additional folders representing
# additional modules that would then be listed as dependencies of this one.
# For example, a 'note' section could have the submodules 'note.create',
# 'note.delete', 'note.edit', etc.
#
# Regardless, so long as dependencies are managed correctly, the build process
# will automatically take take of the rest.
###
do (app=angular.module "sortirDeParis.home", [
  'ui.router'
  'sortirDeParis.home.resource'
]) ->
  app.config ($stateProvider) ->
    $stateProvider.state 'home',
      url: '/home'
      views:
        "main":
          controller: 'HomeController'
          templateUrl: 'home/home.tpl.html'
      data:
        pageTitle: 'Home'

  # As you add controllers to a module and they grow in size, feel free to
  # place them in their own files. Let each module grow organically, adding
  # appropriate organization and sub-folders as needed.
  app.controller 'HomeController', [
    '$scope', 'LxDialogService', 'LxProgressService', 'Cities',
    '$location', '$anchorScroll',
    ($scope, LxDialogService, LxProgressService, Cities,
    $location, $anchorScroll ) ->

      $scope.cities = []
      getCities = ()->
        onError = (error)->
          console.log error
        onSuccess = (success) ->
          console.log success.towns
          $scope.cities = success.towns.map (town) ->
            town.latitude = town.lat
            town.longitude = town.lng
            console.log town
            town

        Cities.cities(
          60 * $scope.from,
          60 * $scope.to
        )
          .then onSuccess, onError

      changeRange = ( from, to )->
        $scope.from = from
        $scope.to = to
        getCities()

      changeRange( 60, 90 )

      $scope.active =
        city:
          id: null

      $scope.markerClick = ( marker )->
        console.log marker
        $scope.map.center =
          longitude: marker.position.D
          latitude: marker.position.k
        $scope.active.city.id = marker.key
        $location.hash( marker.key )
        $anchorScroll()

      $scope.selectCity = (city) ->
        console.log $scope.map
        $scope.active.city.id = city.id
        $scope.map.center =
          latitude: city.lat
          longitude: city.lng
        $scope.map.zoom = 11

      $scope.options =
        type: "double"
        min: 0
        max: 480
        from: $scope.from
        to: $scope.to
        drag_interval: true
        prettify: (num)->
          min = num % 60
          hours = ( num - min ) / 60
          if hours < 10
            hours = "0" + hours
          if min < 10
            min = "0" + min
          hours + "h" + min
        step: 10
        max_interval: 90
        onFinish: (obj) ->
          changeRange( obj.from, obj.to )

      $scope.map =
        control: {}
        center:
          latitude: 48.853
          longitude: 2.85
        zoom: 9
  ]
