Rails.application.routes.draw do
  
  root 'products#main'
  resources :orders 
  patch '/order/add_to_cart', to: 'orders#add_to_cart', as: 'add_to_cart'
  
  resources :order_items, only: [:create, :destroy]
  
  resources :products, except: [:destroy]
  get '/products/retire/:id', to: 'products#retire', as: "retire"
  
  resources :merchants, only: [:index, :show]
  get '/merchants/dashboard/:id', to: 'merchants#dashboard', as: "dashboard"
  
  resources :categories, only: [:index, :show, :new, :create]
  
  # get "/login", to: "merchants#login_form", as: "login"
  # post "/login", to: "merchants#login"
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create"
  delete "/logout", to: "merchants#destroy", as: "logout" 
  
  resources :products do
    resources :reviews, only: [:new, :create]
  end
  
  resources :reviews
end

