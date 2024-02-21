Rails.application.routes.draw do
  devise_for :users

  resources :tasks do
    collection do
      get 'sort_by_due_date'
      get 'search'
    end
  end

  post '/users', to: 'users#create'
end
