//= require moment
//= require jquery
//= require jquery_ujs
//= require bootstrap-datetimepicker
//= require bootstrap-sprockets
//= require angular-1.3.0-beta.min

//= require ./configs/ngRails
//= require ./configs/myDatetimePicker

//= require ./modules/forms

//= require ./controllers/expenses

//= require_self

(function() {
  "use strict";

  angular.module('application', ['ngRails', 'myForms', 'controllers']);
})();
