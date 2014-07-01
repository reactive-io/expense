module Api
  class ExpensesController < ApiController
    def index
      render json: {expenses: current_user.expense_items}
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