Rails.application.routes.draw do
  root 'sessions#new'

  get 'login' => 'sessions#new', as: 'login'
  get 'logout' => 'sessions#destroy', as: 'logout'

  # front end
  resource :session, only: [:new, :create, :destroy]
  resources :sites do
    member { get :pixel }
    resources :tracking_links
  end
  resources :users, except: [:show]

  # redirects / tracking
  namespace :track do
    resources :clicks
    resources :conversions
  end
  get 'r/:token', to: 'track/clicks#new'
end
