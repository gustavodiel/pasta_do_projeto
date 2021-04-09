Rails.application.routes.draw do
  root 'home#index', as: :home

  devise_for :users, controllers: {
    sessions: 'user/sessions'
  }

  post 'allow_login/:token', controller: 'user/passwordless_login', action: 'allow_login', as: :allow_login
  get 'login/:token', controller: 'user/passwordless_login', action: 'login', as: :do_login

  resources :images
end
