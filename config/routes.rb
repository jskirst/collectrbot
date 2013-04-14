Collectrbot::Application.routes.draw do
  get '/pages' => 'pages#index'
  post '/pages' => 'pages#create'
  get '/pages/find' => 'pages#find'
  
  devise_for :users
  
  get 'api/login' => 'api_sessions#create'
  
  root to: 'pages#index'
end
