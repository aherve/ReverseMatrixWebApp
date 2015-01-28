do (app=angular.module "trouverDesTerrains.projetDetail", [
  'ui.router'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'main.projets.detail',
      url: '/:projetId'
      views:
        "main@main":
          controller: 'ProjetDetailController'
          templateUrl: 'app/main/projets/projetDetail/projetDetail.html'
      data:
        pageTitle: 'Détail du projet'
  ]

  app.controller 'ProjetDetailController', [
    '$scope', '$stateParams',
    ($scope, $stateParams) ->
      $scope.projetId = $stateParams.projetId
      init = ->
        # Initialize

      init()
  ]
