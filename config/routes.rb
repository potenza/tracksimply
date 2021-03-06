Rails.application.routes.draw do
  root 'sites#index'

  get 'login' => 'sessions#new', as: 'login'
  get 'logout' => 'sessions#destroy', as: 'logout'

  # front end
  resources :import_formats, except: [:show, :edit, :update]
  resource :session, only: [:new, :create, :destroy]
  resources :sites do
    member { get :pixel }
    resources :imports, except: [:edit, :update]
    resources :tracking_links
  end
  resources :users, except: [:show]

  namespace :api do
    resources :sites, only: [] do
      member do
        get :graph, :table
      end
    end
  end

  # redirects / tracking
  namespace :track do
    resources :visits
    resources :conversions
  end

  get 'r/:token', to: 'track/visits#new'

  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end
end
