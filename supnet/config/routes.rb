Rails.application.routes.draw do
  root "home#index"

  # get 'home/index'

  resources :nodes
  resources :jet_fuels
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

end
