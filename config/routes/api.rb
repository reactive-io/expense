Expense::Application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    resources :expenses
  end
end
