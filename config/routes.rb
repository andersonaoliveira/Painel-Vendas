Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  devise_for :users
  root to: 'home#index'

  get 'search_clients', to: 'clients#search'
  get 'search_orders', to: 'orders#search'
  get 'plans', to: 'orders#plans'
  get 'values', to: 'orders#values'
  
  resources :orders, only: %i[index show edit update] do
    get 'canceled', to: 'orders#canceled', on: :collection
    get 'review_cancelation', to: 'orders#review_cancelation', on: :member
    patch :cancel_order , on: :member, as: 'cancel'
  end

  resources :commissions, only: %i[index]
    resources :sellers, only: %i[index new create show] do
    get 'commissions', on: :member
    patch :change_status, on: :member
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get '/orders/clients/:id', to: 'orders#clients', as: 'client'
      resources :orders, only: %i[show create] do
        patch 'pending', to: 'orders#pending'
        patch 'concluded', to: 'orders#concluded'
        patch 'canceled', to: 'orders#canceled'
      end
    end
  end
  
  resources :clients do
    resources :orders, only: %i[new create], on: :member
    get 'review_deactivation', to: 'clients#review_deactivation', on: :member
    patch :deactivate_cpf , on: :member
    patch :activate_cpf, on: :member
  end
end
