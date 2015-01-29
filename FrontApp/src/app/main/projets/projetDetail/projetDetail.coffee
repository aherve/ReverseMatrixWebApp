do (app=angular.module "trouverDesTerrains.projetDetail", [
  'ui.router'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider
      .state 'main.projects.detail',
        url: '/:projectId'
        abstract: true
        resolve: [
          'Project', '$stateParams',
          (Project, $stateParams)->
            Project.loadLands( $stateParams.projectId )
        ]

      .state 'main.projects.detail.new',
        url: '/nouveaux'
        views:
          "main@main":
            templateUrl: 'app/main/projets/projetDetail/liste.html'
            controller: 'LandsListController'
          "title@main":
            template: '{{ project.title }}'
            controller: 'LandsListController'

      .state 'main.projects.detail.favourite',
        url: '/favoris'
        views:
          "main@main":
            templateUrl: 'app/main/projets/projetDetail/liste.html'
            controller: 'LandsListController'
          "title@main":
            template: '{{ project.title }}'
            controller: 'LandsListController'

      .state 'main.projects.detail.archived',
        url: '/archives'
        views:
          "main@main":
            templateUrl: 'app/main/projets/projetDetail/liste.html'
            controller: 'LandsListController'
          "title@main":
            template: '{{ project.title }}'
            controller: 'LandsListController'
  ]

  app.controller 'ProjetDetailController', [
    '$scope', '$state',
    ($scope, $state) ->
      $scope.$state = $state
  ]

  app.controller 'LandsListController', [
    '$scope', '$state', 'Project', '$stateParams',
    ($scope, $state, Project, $stateParams) ->

      $scope.$state = $state
      $scope.status =
        switch $state.current.name
          when 'main.projects.detail.new' then 0
          when 'main.projects.detail.archived' then -1
          when 'main.projects.detail.favourite' then 1
        
      $scope.project = Project.activeProject()

      $scope.archive = (land)->
        Project.archiveLand( land, $scope.lands, $stateParams.projectId )

      $scope.favourite = (land)->
        Project.favouriteLand( land, $scope.lands, $stateParams.projectId )

      $scope.unSortLand = (land)->
        Project.unSortLand( land, $scope.lands, $stateParams.projectId )

  ]

  app.filter 'landCat', ()->
    (lands, status)->
      land for land in lands when land.status == status

  app.filter 'reverse', ()->
    (items)->
      items.slice().reverse()
