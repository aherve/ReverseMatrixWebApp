do (app=angular.module "trouverDesTerrains.listeProjets", [
  'ui.router'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'main.projets.list',
      url: ''
      views:
        "main@main":
          controller: 'ListeProjetsController'
          templateUrl: 'app/main/projets/listeProjets/listeProjets.html'
      data:
        pageTitle: 'mes projets'
  ]

  app.controller 'ListeProjetsController', ['$scope', ($scope) ->
    init = ->
      # Initialize
      console.log 'pro list crtl'

    init()
  ]
