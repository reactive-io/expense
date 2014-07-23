/* global angular */

(function() {
  "use strict";

  angular.module('controllers').controller('TestsController',
    ['$scope', function ($scope) {

    $scope.index = {
      greeting: 'Hello World'
    };
  }]);
})();
