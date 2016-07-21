Rails.application.routes.draw do
  resources :wishlists, only: [:new, :create]
  devise_for :users
end
