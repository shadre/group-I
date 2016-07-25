Rails.application.routes.draw do
  root to: "wishlists#index"
  resources :wishlists, only: %i(index new create destroy edit update)
  devise_for :users
  get "/i/:token", to: "wishlists_for_guests#show"
end
