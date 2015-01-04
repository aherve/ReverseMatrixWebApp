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
    '$location', '$anchorScroll', '$filter',
    ($scope, LxDialogService, LxProgressService, Cities,
    $location, $anchorScroll, $filter ) ->

      $scope.cities = []
      paris =
        latitude: 48.853
        longitude: 2.35
      $scope.value = 90


      getCities = ()->
        onError = (error)->
          console.log error
        onSuccess = (success) ->
          $scope.cities = success.towns.map (town) ->
            town.latitude = town.lat
            town.longitude = town.lng
            town

        Cities.cities(
          60 * ( $scope.value - 5 ),
          60 * ( $scope.value + 5 )
        )
          .then onSuccess, onError

      changeRange = ( value )->
        $scope.value = value
        getCities()

      changeRange( 95 )

      $scope.active =
        city:
          id: null

      $scope.markerClick = ( marker )->
        $scope.map.center =
          longitude: marker.position.D
          latitude: marker.position.k
        $scope.active.city.id = marker.key
        $location.hash( marker.key )
        $anchorScroll()

      $scope.selectCity = (city) ->
        $scope.active.city.id = city.id
        $scope.map.center =
          latitude: city.lat
          longitude: city.lng


      prettify = (num)->
        min = num % 60
        hours = ( num - min ) / 60
        if hours < 10
          hours = "0" + hours
        if min < 10
          min = "0" + min
        hours + "h" + min

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

      $scope.map =
        control: {}
        center:
          latitude: paris.latitude
          longitude: paris.longitude
        zoom: 6
  ]

  app.filter 'timeFilter', ()->
    (total_seconds)->
      seconds = total_seconds % 60
      minutes = (( total_seconds - seconds ) / 60) % 60
      hours = (total_seconds - ( total_seconds % 3600 )) / 3600
      if minutes < 10
        minutes = '0' + minutes
      hours + 'h' + minutes

