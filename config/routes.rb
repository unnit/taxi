Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'
  get "driverapp", to: "requests#driverapp", as: :driverapp
  get "customerapp", to: "requests#customerapp", as: :customerapp
  get "dashboard", to: "requests#dashboard", as: :dashboard

  resources :requests, only: [:create] do
    member do
      get :accept
      get :complete
    end
  end
  root 'requests#customerapp'
end
