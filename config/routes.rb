Rails.application.routes.draw do
  get "buy_orders/create"
  get "buy_orders/update"
  mount Rswag::Ui::Engine => "/api_docs"
  mount Rswag::Api::Engine => "/api_docs"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :business_owners, only: [ :index, :show ], shallow: true do
        resources :business_entities, only: [ :index, :show ], shallow: true do
          resources :buy_orders, only: [ :index, :create ]
        end
      end
      resources :buyers, only: [ :index, :show ]
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
