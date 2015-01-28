do (app=angular.module "trouverDesTerrains.projets", [
  'ui.router'
  'restangular'
  'trouverDesTerrains.new'
  'trouverDesTerrains.listeProjets'
  'trouverDesTerrains.projetDetail'
]) ->

  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'main.projects',
      url: 'projets'
      abstract: true
  ]

  app.factory 'Project', [
    'ProjectResource', '$state', '$q',
    (ProjectResource, $state, $q )->
      new class Project
        constructor: ()->
          @projects = []

        createProject: (project)->
          that = @
          onSuccess = (success)->
            that.projects.push( success.project )
            $state.go 'main.projects.detail', projectId: success.project.id
          ProjectResource.postProject( project ).then onSuccess

        getProjects: ()->
          that = @
          onSuccess = (success)->
            console.log success
            that.projects = success.projects
          onError = (error)->
            console.log error
          if that.projects.length > 0
            console.log 'q'
            $q.when that.projects
          else
            ProjectResource.myProjects().then onSuccess, onError

        loadProject: (projectId)->
          # two cases : project is in list, or not


  ]

  app.factory 'ProjectResource', [
    'Restangular',
    (Restangular)->
      new class ProjectResource

        myProjects: ->
          Restangular
            .all 'projects'
            .customGET()

        getProject: (projectId)->
          Restangular
            .one 'projects', projectsId
            .get()

        postProject: (project)->
          params =
            town_id: project.town_id
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
            .one 'projects', projectId
            .all 'lands'
            .customGET 'archived'

        getNewLands: (projectId)->
          Restangular
            .one 'projects', projectId
            .all 'lands'
            .customGET 'new'

        getFavouriteLands: (projectId)->
          Restangular
            .one 'projects', projectId
            .all 'lands'
            .customGET 'favorite'
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
