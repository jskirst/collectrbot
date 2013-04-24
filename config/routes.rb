Collectrbot::Application.routes.draw do
  get '/pages' => 'pages#index'
  get '/pages/find' => 'pages#find'
  
  devise_for :users
  
  post 'api/pages' => 'api_pages#create'
  get 'api/login' => 'api_sessions#create'
  
  root to: 'pages#index'
end
