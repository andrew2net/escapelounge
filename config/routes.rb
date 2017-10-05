Rails.application.routes.draw do

  devise_for :users
  root to: "pages#home"
  get 'pages/home'

  resources :hints
  resources :game_steps
  resources :games do
    post :table, on: :collection
    post :start
    post :pause
    post :resume
    get 'step/:step_id', action: :step
  end
  get '/games_admin', to: 'games#games_admin_list'
  resources :users
end
