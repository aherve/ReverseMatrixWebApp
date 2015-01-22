do (app=angular.module 'sortirDeParis.resource', [
  'restangular'
]) ->
  app.factory 'Lands', [
    'Restangular', 'Loading',
    (Restangular, Loading)->
      new class Lands
        constructor: ->
          @lands = []

        filter: (min_traject, max_traject, min_surface,
          max_surface, archived, inactive)->
            that = @
            onSuccess = (success)->
              console.log success
              that.lands = success.lands
              Loading.stop()

            onError = (error)->
              console.log error
              Loading.stop()

            params =
              min_surface: min_surface
              max_surface: max_surface
              min_traject: min_traject
              max_traject: max_traject
              include_archived: archived || -1
              include_inactive: inactive || -1

            Loading.start()
            Restangular
              .all('lands')
              .customGET(null, params)
              .then(onSuccess, onError)

        detail: (id)->
          Restangular
            .one 'lands', id
            .get()
  ]
