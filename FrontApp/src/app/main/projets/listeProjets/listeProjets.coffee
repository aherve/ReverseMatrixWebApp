do (app=angular.module "trouverDesTerrains.listeProjets", [
  'ui.router'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'main.projects.list',
      url: ''
      views:
        "main@main":
          controller: 'ListeProjetsController'
          templateUrl: 'app/main/projets/listeProjets/listeProjets.html'
      data:
        pageTitle: 'mes projets'
      resolve:
        projects: [
          'Project',
          (Project)->
            onSuccess = (success)->
              success
            onError = (error)->
              console.log error
            Project.getProjects().then onSuccess, onError
        ]
  ]

  app.controller 'ListeProjetsController', [
    '$scope', 'Project',
    ($scope, Project) ->
      $scope.Project = Project

  ]