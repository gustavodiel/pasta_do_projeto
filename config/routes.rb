Rails.application.routes.draw do
  devise_for :users

  resources :images

  root 'home#index', as: :home
end
