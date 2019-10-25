Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'products#main'
  resources :orders 
  resources :products, except: [:destroy]
  
  delete '/order/delete_from_cart', to: 'orders#delete_from_cart', as: 'delete_item'
  patch '/order/add_to_cart', to: 'orders#add_to_cart', as: 'add_to_cart'
  
end

