module Api
  class ExpensesController < ApiController
    def index
      expenses = current_user.expense_items

      expenses = expenses.where(id: params[:id]) if params[:id].present?

      expenses = expenses.where('description ilike ? ', "#{params[:description]}%") if params[:description].present?
      expenses = expenses.where('comment ilike ? ', "%#{params[:comment]}%") if params[:comment].present?

      if params[:expensed_at]
        expenses = expenses.where('expensed_at >= ?', params[:expensed_at][:gte]) if params[:expensed_at][:gte].present?
        expenses = expenses.where('expensed_at <= ?', params[:expensed_at][:lte]) if params[:expensed_at][:lte].present?
      end

      if params[:amount]
        expenses = expenses.where('amount >= ?', params[:amount][:gte]) if params[:amount][:gte].present?
        expenses = expenses.where('amount <= ?', params[:amount][:lte]) if params[:amount][:lte].present?
      end

      render json: {expenses: expenses}
    end

    def create
      values = params
               .require(:expense)
               .permit(:expensed_at, :description, :comment, :amount)

      expense = current_user.expense_items.build(values)

      if expense.save
        render json: {expense: expense}
      else
        render json: {errors: expense.errors}, status: :unprocessable_entity
      end
    end

    def update
      values = params
              .require(:expense)
              .permit(:expensed_at, :description, :comment, :amount)

      expense = current_user.expense_items.find(params[:id])

      if expense.update_attributes(values)
        render json: {expense: expense}
      else
        render json: {errors: expense.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      current_user.expense_items.find(params[:id]).destroy

      render json: {status: :ok}
    end
  end
end