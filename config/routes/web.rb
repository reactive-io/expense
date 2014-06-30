Expense::Application.routes.draw do
  namespace :web do
    resources :expenses
  end
end
