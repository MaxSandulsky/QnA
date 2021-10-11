Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  concern :voteable do
    post :upvote, on: :member
    post :downvote, on: :member
  end

  resources :questions, only: %i[index show new create update destroy], concerns: :voteable do
    patch :remove_attachment, on: :member

    resources :answers, shallow: true, only: %i[create update destroy], concerns: :voteable do
      patch :mark, on: :member
      patch :remove_attachment, on: :member
    end
  end

  resources :rewards, only: :index
end
