Rails.application.routes.draw do

  get 'games_history', to: 'games_history#index'

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
    post :set_popup_not_show, on: :collection
  end

  resources :user_games, only: :index do
    get "step(/:step_id)", action: :step, as: :step
    post "step/:step_id", action: :answer
    post "step/:step_id/hint", action: :hint, as: :step_hint
    post "check_answer/:id", action: :check_answer, on: :collection
    post :end
    get :result
  end

  resources :subscriptions, param: :plan_id, only: :index do
    get :subscribe
    post :subscribe, action: :subscribe_user
    post :unsubscribe, on: :collection
    get :billing, on: :collection
    post :billing, action: :add_card, on: :collection
    post :delete_card, on: :collection
    post :set_default, on: :collection
  end

  post "stripe_webhooks", to: "stripe_webhooks#api"

  namespace :admin do
    resources :users
    resources :games, except: :show
    resources :subscription_plans, except: :show
    resources :grades, except: :show
  end
end
