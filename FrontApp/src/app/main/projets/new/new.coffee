do (app=angular.module "trouverDesTerrains.new", [
  'ui.router'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'main.projects.new',
      url: '/new'
      views:
        "main@main":
          controller: 'NewController'
          templateUrl: 'app/main/projets/new/new.html'
      data:
        pageTitle: 'Nouveau projet'
  ]

  app.controller 'NewController', [
    '$scope', 'Project',
    ($scope, Project) ->
      $scope.project = {
        town_id: '54b7d533616865624fa67700'
      }

      $scope.createProject = ->
        Project.createProject $scope.project
  ]
