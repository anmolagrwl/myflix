Myflix::Application.routes.draw do
  root to: "pages#front"
  get "home", to: "videos#index"

  resources :videos, only: [:index, :show] do
    collection do
      get :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  resources :users, only: [:create]
  resources :sessions, only: [:create]
  
  resources :categories, only: [:show]
  
  # Queue
  get "my_queue", to: "queue_items#index"
  post "add_to_queue", to: "queue_items#add_to_queue"
  resources :queue_items, only: [:destroy]
  post "update_queue", to: "queue_items#update_queue"
 
  # User
  get "register", to: "users#new"
  get "sign_in", to: "sessions#new" 
  get "sign_out", to: "sessions#destroy"

  # Wireframes
  get "ui(/:action)", controller: "ui"
end
