do (app=angular.module "sortirDeParis.fields", [
  'ui.router'
  'sortirDeParis.map'
  'sortirDeParis.list'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'home.fields',
      url: ''
      abstract: true
      views:
        "main":
          controller: 'FieldsController'
          templateUrl: 'home/fields/fields.tpl.html'
  ]

  app.controller 'FieldsController', ['$scope', ($scope) ->
    init = ->
      # Initialize

    init()
  ]
