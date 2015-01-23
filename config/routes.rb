Rails.application.routes.draw do

  root 'home#index'

  resources :categories, only: [:index, :show]
  resources :products
  
  # Admin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)



end
