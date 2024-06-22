# frozen_string_literal: true

Rails.application.routes.draw do
  post 'auth/login', to: 'auth#login'
  post 'auth/signup', to: 'auth#signup'

  resources :brands, only: %i[create update] do
    member do
      patch 'change_state'
    end
  end

  resources :products, only: %i[create update destroy] do
    member do
      patch 'change_state'
    end
  end

  resources :clients, only: %i[create]
  resources :catalogs, only: %i[index]

  resources :cards, only: %i[create] do
    patch 'cancel'
  end

  resources :reports, only: [] do
    collection do
      get 'brand_report'
      get 'client_report'
      get 'client_transactions_report'
    end
  end

  resources :products, only: [] do
    collection do
      post 'assign_to_client', to: 'products#assign_products_to_client'
    end
  end
end
