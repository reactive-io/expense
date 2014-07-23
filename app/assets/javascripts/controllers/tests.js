/* global angular */

(function() {
  "use strict";

  angular.module('controllers').controller('TestsController',
  ['$scope', '$routeParams', function ($scope, $routeParams) {

    $scope.params = JSON.stringify($routeParams);

    $scope.index = {
      greeting: 'Hello World'
    };

    $scope.show = {
      id: $routeParams.id
    };
  }]);
})();
