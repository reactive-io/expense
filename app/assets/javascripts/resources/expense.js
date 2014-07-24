/* global angular */

(function() {
  "use strict";

  angular.module('resources').factory('Expense', ['railsResourceFactory', function (railsResourceFactory) {
    return railsResourceFactory({
      url: '/expenses',
      name: 'expense'
    });
  }]);
})();
