Rails.application.routes.draw do
  root 'users#index'

  get '/users', to: 'users#index', as: :users
  get '/users/:id/edit', to: 'users#edit', as: :edit_user
  put '/users/:id', to: 'users#update'
  patch '/users/:id', to: 'users#update'

  get "up" => "rails/health#show", as: :rails_health_check
end
