Rails.application.routes.draw do
  
  root 'products#main'
  get '/orders/find', to: 'orders#find', as: "find_my_order"
  get '/orders/search', to: 'orders#search', as: "search_order"
  resources :orders, only: [:show, :edit, :update] do
    resources :order_items, only: [:update, :destroy]
  end 
  
  resources :order_items, only: [:create]
  
  resources :products, except: [:destroy]
  post '/products/retire/:id', to: 'products#retire', as: "retire"
  
  resources :merchants, only: [:index, :show]
  get '/merchants/dashboard/:id', to: 'merchants#dashboard', as: "dashboard"
  
  resources :categories, only: [:index, :show, :new, :create]
  
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout" 
  
  resources :products do
    resources :reviews, only: [:new, :create]
  end
  
end
