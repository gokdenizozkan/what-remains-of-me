Rails.application.routes.draw do
  root 'users#index'

  get '/users', to: 'users#index', as: :users
  get '/users/:id/edit', to: 'users#edit', as: :edit_user
  get '/users?user_id=:id', to: 'users#index', as: :user_profile
  put '/users/:id', to: 'users#update', as: :user
  patch '/users/:id', to: 'users#update'

  get "up" => "rails/health#show", as: :rails_health_check
end
