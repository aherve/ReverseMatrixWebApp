do (app=angular.module "sortirDeParis.list", [
  'ui.router'
]) ->
  app.config ['$stateProvider', ($stateProvider) ->
    $stateProvider.state 'home.fields.list',
      url: 'list'
      views:
        "main":
          controller: 'ListController'
          templateUrl: 'home/fields/list/list.tpl.html'
      data:
        pageTitle: 'list/list.tpl.html'
  ]

  app.controller 'ListController', ['$scope', ($scope) ->
  ]
