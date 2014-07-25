Expense::Application.routes.draw do
  concern :searchable do
    collection do
      post 'search'
    end
  end

  namespace :api, defaults: {format: 'json'} do
    resources :expenses, concerns: :searchable
  end
end
