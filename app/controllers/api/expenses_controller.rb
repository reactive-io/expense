module Api
  class ExpensesController < ApiController
    def search
      @results, @counts = search_results(current_user.expense_items.search(params[:q]))
    end

    def create
      values = params
               .require(:expense)
               .permit(:expensed_at, :description, :comment, :amount)

      expense = current_user.expense_items.build(values)

      if expense.save
        render json: expense
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
        render json: expense
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