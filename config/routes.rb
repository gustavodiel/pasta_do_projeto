Rails.application.routes.draw do
  root 'home#index', as: :home

  devise_for :users, controllers: {
    sessions: 'user/sessions'
  }

  get 'allow_login/:token', controller: 'user/passwordless_login', action: 'allow_login', as: :allow_login
  get 'login/:id', controller: 'user/passwordless_login', action: 'login', as: :do_login

  resources :images
end
