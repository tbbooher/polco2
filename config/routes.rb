Polco2::Application.routes.draw do

  resources :legislators
  resources :subjects
  resources :bills

  get "represent/house_bills"
  get "represent/senate_bills"
  post "bills/add_vote", as: :add_vote

  root :to => "home#index"
  resources :users # , :only => [ :show, :edit, :update ]

  match '/auth/:provider/callback' => 'sessions#create'
  match '/signin' => 'sessions#new', :as => :signin
  match '/signout' => 'sessions#destroy', :as => :signout
  match '/auth/failure' => 'sessions#failure'

  # bills routes

end
