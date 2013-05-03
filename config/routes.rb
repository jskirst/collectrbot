Collectrbot::Application.routes.draw do
  get '/pages' => 'pages#index'
  get '/pages/find' => 'pages#find'
  put '/pages/:id/trash' => 'pages#trash'
  post '/pages/trash' => 'pages#trash'
  put '/pages/:id/archive' => 'pages#archive'
  post '/pages/archive' => 'pages#archive'
  put '/pages/:id/favorite' => 'pages#favorite'
  put '/pages/:id/share' => 'pages#share'
  
  devise_for :users
  
  post 'api/pages' => 'api_pages#create'
  get 'api/login' => 'api_sessions#create'
  
  root to: 'pages#index'
end
