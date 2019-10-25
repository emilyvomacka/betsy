Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :orders
  resources :products, except: [:destroy]
  resources :merchants, only: [:index, :show]

  post "/login", to: "users#login"
  get "/auth/github", as: "github_login"
  get '/products/retire/:id', to: 'products#retire', as: "retire"
  get "/auth/:provider/callback", to: "users#create"
  
end
