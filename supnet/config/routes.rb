Rails.application.routes.draw do
  devise_for :users
  # unauthenticated do
  #   root :to => 'home#index'
  # end

  root "home#index"

  resources :products do
    post :send_pcf, on: :member
  end
  resources :vendors
  resources :customers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

end