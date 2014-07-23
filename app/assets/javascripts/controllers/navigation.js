/* global angular */

(function() {
  "use strict";

  angular.module('controllers').controller('NavigationController',
    ['$scope', '$location', function ($scope, $location) {

    $scope.isActive = function (viewLocation) {
      return viewLocation === $location.path();
    };
  }]);
})();
