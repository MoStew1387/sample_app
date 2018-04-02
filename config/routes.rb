Rails.application.routes.draw do
  get 'session/new'

  get 'users/new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root page
  root 'static_pages#home'
  
  # static pages
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  
  # users
  get '/signup', to: 'users#new'
  #sessions
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  # resources
  resources :users
  
end
