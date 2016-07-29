Rails.application.routes.draw do
  resources :wishlists_for_guests, path: "/i/", param: :token, only: [:show]
  devise_for :users, skip: [:sessions, :registrations]

  authenticated :user do
    root to: "wishlists#index"
  end

  devise_scope :user do
    root to: "devise/sessions#new"

    get "sign_in" => "devise/sessions#new", as: :new_user_session
    post "sign_in" => "devise/sessions#create", as: :user_session

    get "sign_up" => "devise/registrations#new", as: :new_user_registration
    post "sign_up" => "devise/registrations#create", as: :user_registration

    delete "sign_out" => "devise/sessions#destroy", as: :destroy_user_session
  end

  resources :wishlists do
    resources :items, only: %i(new create edit update destroy) do
      resources :reservations, only: %i(create destroy)
    end
  end
end
