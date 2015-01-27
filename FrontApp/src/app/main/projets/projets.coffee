do (app=angular.module "trouverDesTerrains.projets", [
  'ui.router'
  'trouverDesTerrains.new'
  'trouverDesTerrains.listeProjets'
  'trouverDesTerrains.projetDetail'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'main.projets',
      url: 'projets'
      abstract: true
  ]
