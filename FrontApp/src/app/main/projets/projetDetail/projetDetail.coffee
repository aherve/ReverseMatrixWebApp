do (app=angular.module "trouverDesTerrains.projetDetail", [
  'ui.router'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider
      .state 'main.projects.detail',
        url: '/:projectId'
        abstract: true
        views:
          "main@main":
            templateUrl: 'app/main/projets/projetDetail/projetDetail.html'
            controller: 'ProjetDetailController'

      .state 'main.projects.detail.new',
        url: '/nouveaux'
        views:
          "main":
            templateUrl: 'app/main/projets/projetDetail/liste.html'
            controller: 'LandsListController'
        resolve:
          lands: [ 'ProjectResource', '$stateParams', (ProjectResource, $stateParams)->
            onSuccess = (success)->
              success.new_lands
            onError = (error)->
              console.log error
            ProjectResource.getNewLands( $stateParams.projectId ).then onSuccess
          ]

      .state 'main.projects.detail.favourite',
        url: '/favoris'
        views:
          "main":
            templateUrl: 'app/main/projets/projetDetail/liste.html'
            controller: 'LandsListController'
        resolve:
          lands: [ 'ProjectResource', '$stateParams', (ProjectResource, $stateParams)->
            onSuccess = (success)->
              success.favorite_lands
            ProjectResource.getFavouriteLands( $stateParams.projectId ).then onSuccess
          ]

      .state 'main.projects.detail.archived',
        url: '/archives'
        views:
          "main":
            templateUrl: 'app/main/projets/projetDetail/liste.html'
            controller: 'LandsListController'
        resolve:
          lands: [ 'ProjectResource', '$stateParams', (ProjectResource, $stateParams)->
            onSuccess = (success)->
              success.archived_lands
            ProjectResource.getArchivedLands( $stateParams.projectId ).then onSuccess
          ]
  ]

  app.controller 'ProjetDetailController', [
    '$scope', '$state',
    ($scope, $state) ->
      $scope.$state = $state
  ]

  app.controller 'LandsListController', [
    '$scope', 'lands', '$state',
    ($scope, lands, $state) ->
      $scope.$state = $state
      $scope.test = "lol"
      $scope.lands = lands
  ]
