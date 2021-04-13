Rails.application.routes.draw do
  root 'home#index', as: :home

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  namespace :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: 'api/users/sessions' }

    get 'me', controller: 'users/info', action: :me, as: :user_info
  end

  post 'allow_login/:token', controller: 'user/passwordless_login', action: 'allow_login', as: :allow_login
  get 'login/:token', controller: 'user/passwordless_login', action: 'login', as: :do_login

  resources :images
end
