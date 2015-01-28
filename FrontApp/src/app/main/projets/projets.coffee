do (app=angular.module "trouverDesTerrains.projets", [
  'ui.router'
  'restangular'
  'trouverDesTerrains.new'
  'trouverDesTerrains.listeProjets'
  'trouverDesTerrains.projetDetail'
]) ->

  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'main.projets',
      url: 'projets'
      abstract: true
  ]

  app.factory 'Projet', [
    'Restangular',
    (Restangular)->
      new class Projet

        myProjects: ->
          Restangular
            .all 'projects'
            .get()

        getProject: (projectId)->
          Restangular
            .one 'projects', projectsId
            .get()

        postProject: (project)->
          params =
            townId: project.townId
            name: project.name
            min_surface: project.min_surface
            max_surface: project.max_surface
            max_distance: project.max_distance
          Restangular
            .all 'projects'
            .customPOST params

        townsTypeahead: (string)->
          Restangular
            .all 'towns'
            .customPOST string, 'typeahead'

        getArchivedLands: (projectId)->
          Restangular
            .one 'project', projectId
            .customGET null, 'archived'

        getCurrentLands: (projectsId)->
          Restangular
            .one 'project', projectId
            .customGET null, 'current'

        getFavouriteLands: (projectsId)->
          Restangular
            .one 'project', projectId
            .customGET null, 'favourite'
  ]

  app.factory 'Land', [
    'Restangular',
    (Restangular)->
      new class Land
        
        score: ( projectId, landId, score )->
          Restangular
            .one 'projects', projectId
            .one 'lands', landId
            .customPOST( score: score, 'score' )

  ]
