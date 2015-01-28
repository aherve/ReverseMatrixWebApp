do (app=angular.module "trouverDesTerrains.main", [
  'ui.router'
  'trouverDesTerrains.projets'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'main',
      url: '/'
      abstract: 'true'
      views:
        "main":
          controller: "MainController"
          templateUrl: 'app/main/main.html'
      data:
        pageTitle: 'main'
  ]

  app.controller 'MainController', ->
