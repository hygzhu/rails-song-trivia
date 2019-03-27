Rails.application.routes.draw do

  get 'password_resets/new'
  get 'password_resets/edit'
  
  resources :users
  resources :songs
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :playlists do 
    member do
      get :songs
    end
  end
  resources :playlist_song_relationships, only: [:create, :destroy]

  root 'static_pages#home'

  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  get '/trivia', to: 'trivia#index'
  get '/trivia/simple', to: 'trivia#new_game'
  get '/trivia/autocomplete_song_source'
  post '/trivia', to: 'trivia#submit'
  delete '/logout',  to: 'sessions#destroy'



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
