Rails.application.routes.draw do

  resources :attachments
  resources :comments
  resources :priorities
  resources :request_types
  resources :roles
  resources :sessions, only: [:create, :new, :destroy]
  resources :statuses
  resources :tasks
  resources :verticals

  put '/update_priorities/', to: 'attachments#update_priorities'

  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'

  resources :users do
    member do
      post '/reset_login_attempts', action:'reset_login_attempts'
      get '/serve_small',  action: 'serve_small'
      get '/serve_medium', action: 'serve_medium'
      get '/serve_large',  action: 'serve_large'
    end
  end

  get ':id/serve_doc', to: 'attachments#serve_doc'
  get ':id/serve_thumb', to: 'attachments#serve_thumb'
  get '/delete_doc', to: 'attachments#destroy'
  get '/delete_avatar', to: 'users#destroy_avatar'

  root 'sessions#new'
end
