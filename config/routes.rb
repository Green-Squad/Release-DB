Rails.application.routes.draw do

  root 'home#index'
  
  resources :categories,  only: [:index, :show]
  resources :products,    except: [:new, :edit]
  resources :regions,     only: [:index, :show]
  resources :media,       only: [:index, :show]
  resources :releases,    except: [:new, :edit]
  
  get   'feed',                     to: 'approvals#feed',       as: 'feed'  
  get   '/approvals/approve/:id',   to: 'approvals#approve',    as: 'approvals_approve'
  get   '/approvals/reject/:id',    to: 'approvals#reject',     as: 'approvals_reject'
  get   'search-items',             to: 'search#autocomplete',  as: :search_autocomplete
  get   'search',                   to: 'search#search',        as: :search
  
  # Admin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

end
