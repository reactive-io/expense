/* global _ */

(function() {
  "use strict";

  _.mixin({
    clean: function(input) {
      var clone = _.cloneDeep(input);

      function cleanValue(value) {
        if (_.isArray(value)) {
          return _.reject(value, function(v) {
            return _.isNull(v) || _.isUndefined(v) || v === "";
          }).map(cleanValue);
        }

        else if (_.isPlainObject(value)) {
          _.each(value, function(v, k) {
            if (_.isArray(v)) {
              value[k] = cleanValue(v);
            }
            else if (_.isPlainObject(v)) {
              cleanValue(v);
            }
            else if (_.isNull(v) || _.isUndefined(v) || v === "") {
              delete value[k];
            }
          });

          return value;
        }

        else {
          return value;
        }
      }

      return cleanValue(clone);
    }
  });
})();
