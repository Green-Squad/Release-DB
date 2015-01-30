Rails.application.routes.draw do

  root 'home#index'

  resources :categories, only: [:index, :show]
  resources :products
  resources :regions
  resources :media
  resources :releases
  
  get '/approvals/approve/:id',   to: 'approvals#approve',  as: 'approvals_approve'
  get '/approvals/reject/:id',    to: 'approvals#reject',   as: 'approvals_reject'
  
  # Admin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

end
