Rails.application.routes.draw do

  devise_for :users
  root to: "pages#home"
  get 'pages/home'

  resources :hints
  resources :game_steps
  resources :games do
    post :table, on: :collection
    get :start
    post :pause
    post :resume
    get "step(/:step_id)", action: :steps_flow, as: :steps_flow
  end
  get '/games_admin', to: 'games#games_admin_list'
  scope :admin do
    resources :users
  end
end
