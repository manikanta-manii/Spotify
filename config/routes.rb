Rails.application.routes.draw do
  namespace :admin do
    root to: 'dashboard#index'
    resources :songs
    resources :albums
    resources :artists
  end
  devise_for :users , controllers: { registrations: 'users/registrations' , omniauth_callbacks: "users/omniauth_callbacks", sessions: 'users/sessions' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # Defines the root path route ("/")
  # root "posts#index"
  root 'home#index'
  get "admin_dashboard" => "home"
  get "all_artists" => "home"
  resources :artists
  resources :albums
  resources :songs
  resources :playlists do
    member do
      post :add_song
      delete :remove_song
    end
  end

end
