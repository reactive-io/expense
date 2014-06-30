module Api
  class ExpensesController < ApiController
    def index
      @expenses = current_user.expense_items
    end
  end
end