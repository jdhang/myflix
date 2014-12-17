Myflix::Application.routes.draw do
  
  root 'pages#front'
  
  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index'
  get 'signin', to: 'sessions#new'
  post 'signin',  to: 'sessions#create'
  get 'register', to: 'users#new'
  get 'signout', to: 'sessions#destroy'

  resources :users

  resources :videos do
    resources :reviews, only: [:create]
    collection do
      get 'search', to: "videos#search"
    end
  end
  resources :categories

  get 'myqueue', to: "queue_items#index"
  resources :queue_items, only: [:create, :destroy]
end
