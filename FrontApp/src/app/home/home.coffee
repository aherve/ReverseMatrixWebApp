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
do (app=angular.module "lumxTest.home", [
  'ui.router'
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
  app.controller 'HomeController',
    ($scope, LxDialogService, LxProgressService ) ->

      $scope.openDialog = (dialogId) ->
        console.log 'lol'
        LxDialogService.open(dialogId)

      $scope.options =
        type: "double"
        min: 0
        max: 360
        from: 60
        to: 90
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

      $scope.map =
        center:
          latitude: 45
          longitude: -73
        zoom: 8
