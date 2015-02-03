Myflix::Application.routes.draw do

  root 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index'
  get 'signin', to: 'sessions#new'
  post 'signin',  to: 'sessions#create'
  get 'register', to: 'users#new'
  get 'signout', to: 'sessions#destroy'

  get 'people', to: 'followings#people'
  post 'follow', to: 'followings#create'
  delete 'unfollow', to: 'followings#destroy'

  resources :users, only: [:show, :new, :create]

  resources :videos, only: [:index, :show] do
    resources :reviews, only: [:create]
    collection do
      get 'search', to: "videos#search"
    end
  end
  resources :categories

  get 'myqueue', to: "queue_items#index"
  post 'update_queue', to: "queue_items#update_queue"
  resources :queue_items, only: [:create, :destroy]
end
