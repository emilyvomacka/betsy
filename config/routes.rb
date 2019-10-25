Rails.application.routes.draw do
  root 'products#main'
  
  resources :orders
  resources :products, except: [:destroy]
  resources :merchants, only: [:index, :show]
  
  get '/products/retire/:id', to: 'products#retire', as: "retire"
  
end

