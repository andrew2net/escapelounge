Rails.application.routes.draw do

  root to: "pages#home"
  get 'pages/home'

  resources :hints
  resources :game_steps
  resources :games
  resources :users
end
