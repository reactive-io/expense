/*global ko,$*/

(function() {
  "use strict";

  // datetime: { <bootstrap datetimepicker options> }
  // note: http://eonasdan.github.io/bootstrap-datetimepicker for more info
  ko.bindingHandlers.datetime = {
    update: function(element, valueAccessor) {
      var value   = valueAccessor(),
        options = ko.unwrap(value);

      $(element).datetimepicker(options);
    }
  };

  // tooltip: { <bootstrap tooltip options> }
  // note: http://getbootstrap.com/javascript/#tooltips for more info
  ko.bindingHandlers.tooltip = {
    update: function(element, valueAccessor) {
      var value = valueAccessor(),
        options = ko.unwrap(value);

      $(element).tooltip(options);
    }
  };

  // validationError: <item to validate>
  // note: https://github.com/Knockout-Contrib/Knockout-Validation for more info
  ko.bindingHandlers.validationError = {
    update: function(element, valueAccessor) {
      var $element = $(element),
          value = valueAccessor();

      if (!value.isValid()) {
        $element.addClass("has-error");
      }
      else {
        $element.removeClass("has-error");
      }
    }
  };
})();
