Myflix::Application.routes.draw do
  # Sidekiq
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Pages
  root to: "pages#front"
  get "home", to: "videos#index"

  # Videos
  resources :videos, only: [:index, :show] do
    collection do
      get :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  # Sessions
  resources :sessions, only: [:create]
  
  # Categories
  resources :categories, only: [:show]
  
  # Queue
  get "my_queue", to: "queue_items#index"
  post "add_to_queue", to: "queue_items#add_to_queue"
  resources :queue_items, only: [:destroy]
  post "update_queue", to: "queue_items#update_queue"
 
  # User
  resources :users, only: [:create, :show]
  get "register", to: "users#new"
  get "register/:token", to: "users#new_with_invitation_token", as: "register_with_token"
  get "sign_in", to: "sessions#new" 
  get "sign_out", to: "sessions#destroy"
  
  # Relationships
  get "people", to: "relationships#index"
  resources :relationships, only: [:create, :destroy]

  # Wireframes
  get "ui(/:action)", controller: "ui"

  # Forgot Password
  get 'forgot_password', to: "forgot_passwords#new"
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: "forgot_passwords#confirm"
  resources :password_resets, only: [:create, :show] 
  get 'expired_token', to: 'pages#expired_token'

  # Invitations
  resources :invitations, only: [:new, :create]
end