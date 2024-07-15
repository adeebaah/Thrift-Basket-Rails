Rails.application.routes.draw do
  get 'profiles/show'
  get 'authenticated', to: 'sessions#authenticated'

  devise_for :users, controllers: {
    registrations: 'registrations'
  }, path: '', path_names: {
    sign_in: 'login',
    sign_up: 'signup',
    sign_out: 'logout',
  }

  namespace :admin do
    resources :orders
    resources :products do
      resources :stocks
    end

    resources :categories
  end
  devise_for :admins

  root "home#index"

  authenticated :admin_user do
    root to: "admin#index", as: :admin_root
  end

  get '/admin', to: 'admin#index'

  resources :categories, only: [:show]

  resources :products, only: [:show, :index] do
    resources :reviews, only: [:new, :create]
  end

  resource :cart, only: [:show] do
    post 'add_item', on: :collection
    delete 'remove_item/:id', action: :remove_item, as: 'remove_item'
    patch 'increase_quantity/:id', action: :increase_quantity, as: 'increase_quantity'
    patch 'decrease_quantity/:id', action: :decrease_quantity, as: 'decrease_quantity'
    delete 'clear', action: :clear, as: 'clear'
    post 'checkout', on: :collection
    get 'details', on: :collection
    post 'confirm_checkout', on: :collection
  end
  get 'search', to: 'products#search', as: 'search_product'

  get 'about', to: 'home#about', as: 'about'

  resource :wishlist, only: [:show] do
    post 'add_item', on: :collection
    delete 'remove_item/:id', action: :remove_item, as: 'remove_item'
  end

  get 'wishlist_guest', to: 'wishlists#guest', as: 'wishlist_guest'

  get 'profile', to: 'profiles#show', as: 'profile'
  post 'profile', to: 'profiles#update', as: 'edit_profile'
  get 'users/:id/orders', to: 'orders#user_orders', as: 'user_orders'
  post 'reorder_items', to: 'orders#reorder_items', as: 'reorder_items'

  resources :slides, only: [:index]

end
