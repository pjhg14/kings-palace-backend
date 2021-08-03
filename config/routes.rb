Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Create ActionCable route
  mount ActionCable.server => "/cable"

  # Create Model Resources
  resources :users, only: [:show, :create]  
  resources :games, only: [:show, :create]  # Create routes for making games, joining games, viewing games
  resources :moves, only: [:create]  # Create routes for making moves...

  get "/leaderboard", to: "users#leaderboard"
  post "/games/join", to: "games#join"
  post "/games/:id/start", to: "games#start"
  post "/users/login", to: "users#login"

end
