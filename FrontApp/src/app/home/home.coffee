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
    '$scope',
    ($scope) ->

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

