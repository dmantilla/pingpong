Rails.application.routes.draw do
  resources :scores, only: [:index, :new, :create]

  resource :leaderboard, only: :show

  devise_for :users

  root to: "leaderboards#show"
end
