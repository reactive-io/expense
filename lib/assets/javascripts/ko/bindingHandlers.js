/*global ko,$*/

(function() {
  "use strict";

  // datetime: { <bootstrap datetimepicker options> }
  // note: http://eonasdan.github.io/bootstrap-datetimepicker for a list of all options
  ko.bindingHandlers.datetime = {
    update: function(element, valueAccessor) {
      var value   = valueAccessor(),
          options = ko.unwrap(value);

      $(element).datetimepicker(options);
    }
  };
})();
