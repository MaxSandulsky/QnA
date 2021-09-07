Rails.application.routes.draw do
  root to: "questions#index"

  devise_for :users

  resources :questions, only: %i[index show new create update destroy] do
    resources :answers, shallow: true, only: %i[create update destroy] do
    end
  end
end
