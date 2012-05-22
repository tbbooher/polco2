Polco2::Application.routes.draw do

  resources :comments

  resources :legislators
  resources :subjects
  resources :bills
  resources :polco_groups

  # what bills are active?
  get "represent/house_bills"
  get "represent/senate_bills"
  # how are the legislators voting?
  get "represent/legislators_districts"
  get "represent/states"
  # how are you being represented?
  # H3. and S3 house results -- how represented are you in the house?
  match "/represent/:chamber" => "represent#results", as: :results
  # helper to add vote
  post "bills/add_vote", as: :add_vote

  root :to => "home#index"
  resources :users # , :only => [ :show, :edit, :update ]

  match '/auth/:provider/callback' => 'sessions#create'
  match '/signin' => 'sessions#new', :as => :signin
  match '/signout' => 'sessions#destroy', :as => :signout
  match '/auth/failure' => 'sessions#failure'



end
