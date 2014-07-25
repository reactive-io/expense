/* global angular */

(function() {
  'use strict';

  angular.module('rails', []);
  angular.module('directives', []);
  angular.module('controllers', []);

  angular.module('application', ['ngRoute', 'rails', 'directives', 'controllers']);
})();
