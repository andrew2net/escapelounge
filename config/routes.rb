Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: "user/registrations" }
  root to: "pages#home"
  get 'pages/home'

  resources :hints
  resources :game_steps
  resources :games, only: [:index, :show] do
    post :games, on: :collection
    post :start
    post :pause
    post :resume
  end

  resources :user_games, only: :index do
    get "step(/:step_id)", action: :step, as: :step
    post "step/:step_id", action: :answer
    post "step/:step_id/hint", action: :hint, as: :step_hint
    post :end
    get :result
  end

  resources :subscription_plans, only: [:index, :update] do
  end

  namespace :admin do
    resources :users
    resources :games, except: :show
  end
end
