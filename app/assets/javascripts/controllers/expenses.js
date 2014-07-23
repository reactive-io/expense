/* global angular,alert,confirm,moment,$ */

(function() {
  "use strict";

  angular.module('controllers').controller('ExpensesController',
    ['$scope', '$http', function($scope, $http) {

    $scope.modal = {
      isNew: null,

      index: null,

      expense: {
      },

      saveExpense: function() {
        var http;

        if (this.isNew) {
          http = $http.post('/api/expenses', {expense: this.expense}).success(function(data) {
            $scope.table.expenses.push(data.expense);
          }.bind(this));
        }
        else {
          http = $http.patch('/api/expenses/' + this.expense.id, {expense: this.expense}).success(function(data) {
            $scope.table.expenses[this.index] = data.expense;
          }.bind(this));
        }

        http.success(function() {
          $("#expense-modal").modal("hide");
        });

        http.error(function() {
          alert("Seems some values are not correct, please try again.");
        });
      },

      deleteExpense: function(index) {
        if (confirm('Are you sure?')) {
          $http.delete('/api/expenses/' + this.expense.id).success(function() {
            this.splice(index, 1);
          }.bind($scope.table.expenses));
        }
      }
    };

    $scope.filters = {
    };

    $scope.table = {
      expenses: [],

      filterExpenses: function() {
        var http = $http.get('/api/expenses', {params: $scope.filters});

        http.success(function(data) {
          this.expenses = data.expenses;
        }.bind(this));

        http.error(function() {
          alert('Seems some filters are not valid, please try again.');
        });
      },

      newExpense: function() {
        this.isNew = true;
        this.expense = {expensed_at: moment((new Date()).toISOString()).format('YYYY-MM-DD HH:mm:ss')};
      }.bind($scope.modal),

      editExpense: function(expense, index) {
        this.isNew = false;
        this.index = index;
        this.expense = angular.copy(expense);
      }.bind($scope.modal)
    };
  }]);
})();
