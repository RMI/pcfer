Rails.application.routes.draw do
  root "home#index"

  # get 'home/index'

  resources :products
  resources :vendors
  resources :customers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

end