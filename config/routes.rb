Rails.application.routes.draw do
  use_doorkeeper
  root to: 'questions#index'

  devise_for :users

  concern :voteable do
    post :upvote, on: :member
    post :downvote, on: :member
  end

  concern :commentable do
    get :new_comment, on: :member
    post :create_comment, on: :member
  end

  resources :questions, only: %i[index show new create update destroy], concerns: %i[voteable commentable] do
    patch :remove_attachment, on: :member

    resources :comments, shallow: true, only: :create

    resources :answers, shallow: true, only: %i[create update destroy], concerns: %i[voteable commentable] do
      resources :comments, shallow: true, only: :create

      patch :mark, on: :member
      patch :remove_attachment, on: :member
    end
  end

  resources :rewards, only: :index

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :all, on: :collection
      end

      resources :questions, only: %i[index show]
    end
  end

  mount ActionCable.server => '/cable'
end
