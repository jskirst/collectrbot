Collectrbot::Application.routes.draw do
  get '/pages' => 'pages#index'
  get '/pages/find' => 'pages#find'
  put '/pages/:id/trash' => 'pages#trash'
  post '/pages/trash' => 'pages#trash', as: "trash_all_pages"
  put '/pages/:id/archive' => 'pages#archive'
  post '/pages/archive' => 'pages#archive', as: "archive_all_pages"
  put '/pages/:id/favorite' => 'pages#favorite'
  put '/pages/:id/share' => 'pages#share'
  post 'pages/empty' => 'pages#empty', as: "empty_trash"
  
  devise_for :users
  
  resources :users do
    member do
      put :subscribe
      put :unsubscribe
    end
  end
  
  post 'api/pages' => 'api_pages#create'
  get 'api/login' => 'api_sessions#create'
  
  get '/help' => 'misc#help'
  
  root to: 'pages#index'
  
  get '/:id' => 'users#show', as: 'vanity'
end
