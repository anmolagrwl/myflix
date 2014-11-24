Myflix::Application.routes.draw do
  root to: "pages#front"
  get "home", to: "videos#index"

  resources :videos, only: [:index, :show] do
    collection do
      get :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  resources :sessions, only: [:create]
  resources :categories, only: [:show]
  
  # Queue
  get "my_queue", to: "queue_items#index"
  post "add_to_queue", to: "queue_items#add_to_queue"
  resources :queue_items, only: [:destroy]
  post "update_queue", to: "queue_items#update_queue"
 
  # User
  resources :users, only: [:create, :show]
  get "register", to: "users#new"
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
  get 'expired_token', to: 'password_resets#expired'
end