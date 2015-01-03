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
