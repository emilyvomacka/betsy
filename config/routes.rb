Rails.application.routes.draw do
  root "products#root"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :orders
  resources :products, except: [:destroy]
  resources :merchants, only: [:index, :show]
  
  
  # get "/login", to: "merchants#login_form", as: "login"
  # post "/login", to: "merchants#login"
  get "/auth/github", as: "github_login"
  get '/products/retire/:id', to: 'products#retire', as: "retire"
  get "/auth/:provider/callback", to: "merchants#create"
  
end
