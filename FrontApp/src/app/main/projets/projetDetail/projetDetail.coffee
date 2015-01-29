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
            console.log 'resolving project lands'
            Project.loadLands( $stateParams.projectId )
        ]

      .state 'main.projects.detail.new',
        url: '/nouveaux'
        views:
          "main@main":
            templateUrl: 'app/main/projets/projetDetail/liste.html'
            controller: 'LandsListController'

      .state 'main.projects.detail.favourite',
        url: '/favoris'
        views:
          "main@main":
            templateUrl: 'app/main/projets/projetDetail/liste.html'
            controller: 'LandsListController'

      .state 'main.projects.detail.archived',
        url: '/archives'
        views:
          "main@main":
            templateUrl: 'app/main/projets/projetDetail/liste.html'
            controller: 'LandsListController'
  ]

  app.controller 'ProjetDetailController', [
    '$scope', '$state',
    ($scope, $state) ->
      $scope.$state = $state
  ]

  app.controller 'LandsListController', [
    '$scope', '$state', 'Project', '$stateParams', '$timeout',
    ($scope, $state, Project, $stateParams, $timeout) ->

      $scope.$state = $state
      $scope.status =
        switch $state.current.name
          when 'main.projects.detail.new' then 0
          when 'main.projects.detail.archived' then -1
          when 'main.projects.detail.favourite' then 1
        
      $scope.project = Project.activeProject()

      $scope.archive = (land)->
        $scope.project.archived_lands_count += 1
        if $scope.status == 0
          $scope.project.new_lands_count -= 1
        else if $scope.status == 1
          $scope.project.favorite_lands_count -= 1
          console.log( $scope.project )
        Project.archiveLand( land, $scope.project.id )

      $scope.favourite = (land)->
        $scope.project.favorite_lands_count += 1
        if $scope.status == 0
          $scope.project.new_lands_count -= 1
        else if $scope.status == -1
          $scope.project.archived_lands_count -= 1
        console.log( $scope.project )
        Project.favouriteLand( land, $scope.project.id )

      $scope.unSortLand = (land)->
        if $scope.status == -1
          $scope.project.archived_lands_count -= 1
        else if $scope.status == 1
          $scope.project.favorite_lands_count -= 1
        $scope.project.new_lands_count += 1
        console.log( $scope.project )
        Project.unSortLand(land, $scope.project.id)

  ]

  app.filter 'landCat', ()->
    (lands, status)->
      land for land in lands when land.status == status

  app.filter 'reverse', ()->
    (items)->
      items.slice().reverse()

  app.directive 'swipeLeft', [
    '$document',
    ($document)->
      link: (scope, elem, attr)->
        e = elem.parent().parent().parent()
        elem.bind 'click', ()->
          e.addClass('disappearLeft')
          console.log 'left'
  ]

  app.directive 'swipeRight', [
    '$document',
    ($document)->
      link: (scope, elem, attr)->
        e = elem.parent().parent().parent()
        elem.bind 'click', ()->
          e.addClass('disappearRight')
          console.log 'right'
  ]
