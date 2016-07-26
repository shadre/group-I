Rails.application.routes.draw do
  root to: "wishlists#index"
  resources :wishlists
  resources :wishlists_for_guests, path: "/i/", param: :token, only: [:show]
  devise_for :users
end
