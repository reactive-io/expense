/* global angular,jstz,$ */

(function() {
  'use strict';

  var mod = angular.module('rails');

  mod.config(['$httpProvider', function($httpProvider) {
    var getCSRFToken = function() {
      // Rails 3+
      var el = document.querySelector('meta[name="csrf-token"]');
      if (el) {
        el = el.getAttribute('content');
      } else {
        // Rails 2
        el = document.querySelector('input[name="authenticity_token"]');
        if (el) {
          el = el.value;
        }
      }
      return el;
    },
    updateHeaders = function() {
      var headers = $httpProvider.defaults.headers.common, token = getCSRFToken();
      if (token) {
        headers['X-TIME-ZONE'] = jstz.determine().name();
        headers['X-CSRF-TOKEN'] = getCSRFToken;
        headers['X-Requested-With'] = 'XMLHttpRequest';
      }
    };

    updateHeaders();

    if (window.Turbolinks) {
      $(document).bind('page:change', updateHeaders);
    }
  }]);
})();

