module Api
  class ExpensesController < ApiController
    def index
      expenses = current_user.expense_items

      expenses = expenses.where(id: params[:id]) if params[:id].present?

      expenses = expenses.where('description ilike ? ', "%#{params[:description]}%") if params[:description].present?
      expenses = expenses.where('comment ilike ? ', "%#{params[:comment]}%") if params[:comment].present?

      expenses = expenses.where('expensed_at >= ?', params[:expensed_at__gte]) if params[:expensed_at__gte].present?
      expenses = expenses.where('expensed_at <= ?', params[:expensed_at__lte]) if params[:expensed_at__lte].present?

      expenses = expenses.where('amount >= ?', params[:amount__gte]) if params[:amount__gte].present?
      expenses = expenses.where('amount <= ?', params[:amount__lte]) if params[:amount__lte].present?

      render json: {expenses: expenses}
    rescue
      head :bad_request
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