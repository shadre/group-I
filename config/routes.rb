Rails.application.routes.draw do
  resources :wishlists, only: [:new, :create]
  devise_for :users
  get "/i/:token", to: "wishlists_for_guests#show"
end
