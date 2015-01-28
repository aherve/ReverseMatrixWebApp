do (app=angular.module "trouverDesTerrains.new", [
  'ui.router'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'main.projets.new',
      url: '/new'
      views:
        "main@main":
          controller: 'NewController'
          templateUrl: 'app/main/projets/new/new.html'
      data:
        pageTitle: 'Nouveau projet'
  ]

  app.controller 'NewController', [
    '$scope', 'Projet',
    ($scope, Projet) ->
      $scope.project = {
        townId: '54b7d53f616865624fdf8a00'
      }
      $scope.createProject = ->
        Projet.postProject $scope.project
  ]
