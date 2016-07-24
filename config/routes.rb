Rails.application.routes.draw do
  root to: "wishlists#index"
  resources :wishlists, only: [:index, :new, :create]
  devise_for :users
  get "/i/:token", to: "wishlists_for_guests#show"
end
