Rails.application.routes.draw do
  root "dashboard#index"

  resources :users
  resource :session

  resources :trips do
    member do
      patch :end_trip
      get :final_settlement
      get :final_settlement_pdf, to: "reports#final_settlement"
    end

    resources :expenses
    resources :memberships, only: [:create, :destroy]

    # Join Request
    resources :join_requests, only: [:create]

    resources :settlements, only: [:index, :update]
    resources :balances, only: [:index]
  end

  # Invite Link
  get "/join/:token",
      to: "join_requests#show",
      as: :join_trip

  # Owner Actions
  patch "/join_requests/:id/accept",
        to: "join_requests#accept",
        as: :accept_join_request

  patch "/join_requests/:id/reject",
        to: "join_requests#reject",
        as: :reject_join_request
end