do (app=angular.module "lumxTest.about", [
  'ui.router'
]) ->
  app.config ($stateProvider) ->
    $stateProvider.state 'about',
      url: '/about'
      views:
        "main":
          controller: 'AboutController'
          templateUrl: 'about/about.tpl.html'
      data:
        pageTitle: 'About'


  app.controller 'AboutController', ($scope) ->
    init = ->
      # A definitive place to put everything that needs to run
      # when the controller starts. Avoid writing any code outside
      # of this function that executes immediately.

    init()

