do (app=angular.module 'sortirDeParis.resource', [
  'restangular'
]) ->
  app.factory 'Lands', [
    'Restangular', 'Loading',
    (Restangular, Loading)->
      formatCoordinates = (land)->
        land.latitude = land.town_lat
        land.longitude = land.town_lng
        land

      new class Lands
        constructor: ->
          @lands = []

        filter: (min_traject, max_traject, min_surface,
          max_surface, archived, inactive)->
            that = @
            onSuccess = (success)->
              console.log success
              that.lands = success.lands.map( formatCoordinates )
              Loading.stop()

            onError = (error)->
              console.log error
              Loading.stop()

            params =
              min_surface: min_surface
              max_surface: max_surface
              min_traject: min_traject
              max_traject: max_traject
              include_archived: archived
              include_inactive: inactive

            Loading.start()
            Restangular
              .all('lands')
              .customGET(null, params)
              .then(onSuccess, onError)

        detail: (id)->
          Restangular
            .one 'lands', id
            .get()

        interesting: (land)->
          Restangular
            .one 'lands', land.id
            .customPOST null, 'interesting!'
            .then(
              (success) ->
                land.interesting = true
            )

        notInteresting: (land)->
          Restangular
            .one 'lands', land.id
            .customPOST null, 'not_interesting!'
            .then(
              (success) ->
                land.interesting = false
            )

        archive: (land)->
          Restangular
            .one 'lands', land.id
            .customPOST null, 'archive!'
            .then(
              (success) ->
                land.archived = true
            )

        unArchive: (land)->
          Restangular
            .one 'lands', land.id
            .customPOST null, 'unarchive!'
            .then(
              (success) ->
                land.archived = false
            )
  ]
