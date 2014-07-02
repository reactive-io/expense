/*global app,alert,confirm,ko,moment,$*/

(function() {
  "use strict";

  app.ViewModels.Expenses = function Expenses() {
    var self = this;

    $(function() {
      self.filterExpenses();
    });

    self.expenses = ko.observableArray([]);

    self.expenseModal  = ko.observable();
    self.expensePointer = ko.observable();

    self.filters = {
      id: ko.observable(),
      description: ko.observable(),
      comment: ko.observable(),
      amount: {
        gte: ko.observable(),
        lte: ko.observable()
      },
      expensed_at: {
        gte: ko.observable(),
        lte: ko.observable()
      }
    };

    // work around to get the datepicker to always use an ISO-8601 string for date filters
    self.subscriptions = {
      expensed_at: {
        gte: ko.observable(),
        lte: ko.observable()
      }
    };

    $.each(self.subscriptions.expensed_at, function(key, val) {
      val.subscribe(function(newValue) {
        var mnt = moment(newValue, app.ViewModels.Expenses.options.datetimeFormat);

        if (mnt.isValid()) {
          self.filters.expensed_at[key](mnt.toISOString());
        }
        else {
          self.filters.expensed_at[key](undefined);
        }
      });
    });

    self.filterExpenses = function() {
      var ajax = $.ajax("/api/expenses", {data: ko.toJS(self.filters)});

      ajax.done(function(data) {
        self.expenses.removeAll();

        $.each(data.expenses, function() {
          self.expenses.push(new app.ViewModels.Expenses.Expense(this));
        });
      });

      ajax.fail(function() {
        alert("Seems some filters are not valid, please try again.");
      });
    };

    self.newExpense = function() {
      self.expenseModal(new app.ViewModels.Expenses.Expense({
        expensed_at: moment(new Date()).toISOString()
      }));
    };

    self.editExpense = function(expense) {
      self.expenseModal(new app.ViewModels.Expenses.Expense(ko.toJS(expense.values)));
      self.expensePointer(expense);
    };

    self.saveExpense = function() {
      var expense = self.expenseModal(),
          values  = expense.toJS(),
          ajax;

      if (expense.isNew()) {
        ajax = $.ajax("/api/expenses", {type: 'POST', data: {expense: values}})
        .done(function(data) {
          self.expenses.push(new app.ViewModels.Expenses.Expense(data.expense));
        });
      }
      else {
        ajax = $.ajax("/api/expenses/" + expense.values().id(), {type: 'PATCH', data: {expense: values}})
        .done(function(data) {
          $.each(["expensed_at", "description", "comment", "amount"], function() {
            self.expensePointer().values()[this](data.expense[this]);
          });
        });
      }

      ajax.done(function() {
        $("#expense-modal").modal("hide");
        self.expenseModal.error(false);
      });

      ajax.fail(function() {
        alert("Seems some values are not correct, please try again.");
      });
    };

    self.deleteExpense = function() {
      var expense = self.expensePointer();

      if (!confirm("Are you sure?")) { return; }

      $.ajax("/api/expenses/" + expense.values().id(), {type: 'DELETE'})
      .done(function() {
        self.expenses.remove(expense);
      });
    };
  };

  app.ViewModels.Expenses.Expense = function Expense(data) {
    var self = this;

    self.values = ko.validatedObservable({
      id:          ko.observable(data.id),
      description: ko.observable(data.description).extend({required: true}),
      comment:     ko.observable(data.comment),
      amount:      ko.observable(data.amount).extend({required: true, pattern: /^[0-9]*(\.?[0-9]{0,2})$/}),
      expensed_at: ko.observable(data.expensed_at).extend({required: true})
    });

    self.formattedExpensedAt = ko.computed({
      read: function() {
        return moment(self.values().expensed_at()).format(app.ViewModels.Expenses.options.datetimeFormat);
      },
      write: function(newValue) {
        self.values().expensed_at(moment(newValue, app.ViewModels.Expenses.options.datetimeFormat).toISOString());
      }
    });

    self.isNew = ko.computed(function() {
      return !self.values().id();
    });

    self.toJS = function() {
      return {
        description: this.description(),
        comment: this.comment(),
        amount: this.amount(),
        expensed_at: this.expensed_at()
      };
    }.bind(self.values());
  };

  app.ViewModels.Expenses.options = {
    datetimeFormat: 'MM/DD/YYYY h:mm A'
  };
})();