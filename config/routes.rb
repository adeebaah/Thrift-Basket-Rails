Rails.application.routes.draw do
  # Root path
  root "home#index"

  # Devise routes for users with custom controllers
  devise_for :users, controllers: {
    registrations: 'registrations',
    sessions: 'users/sessions'
  }, path: '', path_names: {
    sign_in: 'login',
    sign_up: 'signup',
    sign_out: 'logout',
  }

  # Devise routes for admins
  devise_for :admins

  # Namespace for admin routes
  namespace :admin do
    resources :orders
    resources :products do
      resources :stocks
    end
    resources :categories
  end

  # Authenticated root for admin
  authenticated :admin_user do
    root to: "admin#index", as: :admin_root
  end

  # Admin route
  get '/admin', to: 'admin#index'

  # Profile routes
  get 'profile', to: 'profiles#show', as: 'profile'
  get 'profile/edit', to: 'profiles#edit', as: 'edit_profile'
  patch 'profile', to: 'profiles#update'

  # Additional routes
  get 'profiles/show'
  get 'authenticated', to: 'sessions#authenticated'

  resources :categories, only: [:show]

  resources :products, only: [:show, :index] do
    resources :reviews, only: [:new, :create]
  end
  get 'cart_data', to: 'carts#cart_data'
  get 'wishlist_data', to: 'wishlists#wishlist_data'

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

  get 'users/:id/orders', to: 'orders#user_orders', as: 'user_orders'
  post 'reorder_items', to: 'orders#reorder_items', as: 'reorder_items'

  resources :slides, only: [:index]
end
