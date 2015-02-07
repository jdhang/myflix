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
  get 'forgot_password', to: 'users#forgot_password'
  post 'submit_forgot_password', to: 'users#submit_forgot_password'
  get 'confirm_password_reset', to: 'users#confirm_password_reset'
  get 'link_expired', to: 'users#link_expired'
  get 'reset_password', to: 'users#reset_password'
  post 'submit_reset_password', to: 'users#submit_reset_password'

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
