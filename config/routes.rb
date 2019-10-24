Rails.application.routes.draw do
  resources :products, except: [:destroy]
  
end
