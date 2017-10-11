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
  end

  resources :user_games, only: :index do
    get "step(/:step_id)", action: :step, as: :step
    post "step/:step_id", action: :answer
    get :result
  end

  get '/games_admin', to: 'games#games_admin_list'

  scope :admin do
    resources :users
  end
end
