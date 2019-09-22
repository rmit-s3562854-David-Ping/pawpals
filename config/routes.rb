Rails.application.routes.draw do

  resources :pets
  get 'sessions/new'

  root   'static_pages#home'
  get    '/home',       to: 'static_pages#home'
  get    '/contact-us', to: 'feedback#new'
  post   '/contact-us', to: 'feedback#create'
  get    '/signup',     to: 'users#new'
  post   '/signup',     to: 'users#create'
  get    '/login',      to: 'sessions#new'
  post   '/login',      to: 'sessions#create'
  delete '/logout',     to: 'sessions#destroy'

  resources :users
  resources :account_activations, only: [:edit]
  resources :microposts,          only: [:create, :destroy]
end