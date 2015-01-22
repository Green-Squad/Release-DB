Rails.application.routes.draw do

  resources :categories, only: [:index, :show]
  resources :products
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'welcome#index'

end
