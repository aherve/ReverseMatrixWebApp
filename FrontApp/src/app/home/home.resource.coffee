do (app = angular.module "sortirDeParis.home.resource", [
  'restangular'
]) ->
  app.factory 'Cities', [
    'Restangular',
    ( Restangular )->
      new class Cities
        cities: (t_min, t_max)->
          params =
            t_min: t_min
            t_max: t_max
          Restangular
            .all 'towns'
            .customGET( null, params )
  ]

  app.factory 'Lands', [
    'Restangular',
    (Restangular)->
      new class Lands
        lands: (min_traject, max_traject, min_surface,
          max_surface, include_archived, include_inactive)->

            params =
              min_traject: min_traject
              max_traject: max_traject
              min_surface: min_surface
              max_surface: max_surface
              include_inactive: include_inactive
              include_archived: include_archived

            Restangular
              .all 'lands'
              .customGET null, params
  ]
