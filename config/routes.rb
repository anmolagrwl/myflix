Myflix::Application.routes.draw do
  root to: 'pages#home'

  get 'ui(/:action)', controller: 'ui'

  # get 'register', to: 'users#new'

  resources :users

  resources :videos, only: [:index, :show] do
    collection do
      get :search, to: 'videos#search'
    end
  end
  
  resources :categories, only: [:show]
end
