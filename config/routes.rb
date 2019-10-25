Rails.application.routes.draw do

  root 'products#main'
  resources :orders
  resources :products, except: [:destroy]
  resources :merchants, only: [:index, :show]
  resources :categories, only: [:index, :show, :new, :create]
  
  
  # get "/login", to: "merchants#login_form", as: "login"
  # post "/login", to: "merchants#login"
  get "/auth/github", as: "github_login"
  get '/products/retire/:id', to: 'products#retire', as: "retire"
  get "/auth/:provider/callback", to: "merchants#create"
  delete "/logout", to: "merchants#destroy", as: "logout"
  
end

