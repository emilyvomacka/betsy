Rails.application.routes.draw do
  root 'products#main'
  
  resources :orders
  resources :products, except: [:destroy]
  resources :merchants, only: [:index, :show]
  resources :categories, only: [:index, :show, :new, :create]
  
  get '/products/retire/:id', to: 'products#retire', as: "retire"
  
end

