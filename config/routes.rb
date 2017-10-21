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

  resources :subscriptions, param: :plan_id, only: :index do
    get :subscribe
    post :subscribe, action: :subscribe_user
    get :billing, on: :collection
    post :billing, action: :add_card, on: :collection
    post :delete_card, on: :collection
    post :set_default, on: :collection
  end

  post "stripe_webhooks", to: "stripe_webhooks#api"

  namespace :admin do
    resources :users
    resources :games, except: :show
  end
end
