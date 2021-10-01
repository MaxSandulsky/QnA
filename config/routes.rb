Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions, only: %i[index show new create update destroy] do
    patch :remove_attachment, on: :member

    resources :answers, shallow: true, only: %i[create update destroy] do
      patch :mark, on: :member
      patch :remove_attachment, on: :member
    end
  end
end
