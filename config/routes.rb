Rails.application.routes.draw do

  
  resources :hints
  resources :game_steps
  resources :games
  resources :users
end
