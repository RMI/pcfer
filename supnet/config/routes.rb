Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  # get 'home/index'

  resources :products do
    post :send_pcf, on: :member
  end
  resources :vendors
  resources :customers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

end