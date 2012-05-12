Polco2::Application.routes.draw do

  get "represent/house_bills"

  get "represent/senate_bills"

  resources :subjects

  resources :bills

  root :to => "home#index"
  resources :users # , :only => [ :show, :edit, :update ]
  match '/auth/:provider/callback' => 'sessions#create'
  match '/signin' => 'sessions#new', :as => :signin
  match '/signout' => 'sessions#destroy', :as => :signout
  match '/auth/failure' => 'sessions#failure'

  # bills routes

end
