Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :orders
  resources :products, except: [:destroy]
  resources :merchants, only: [:index, :show]
  
  get '/products/retire/:id', to: 'products#retire', as: "retire"
  
end
