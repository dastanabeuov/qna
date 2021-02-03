Rails.application.routes.draw do
  root to: "questions#index"

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  concern :attachable do
    resources :attachments, shallow: true, only: %i[destroy]
  end

  concern :voteable do
    post :like, :dislike, on: :member
  end
  
  resources :questions do
    concerns :attachable
    concerns :voteable
    resources :comments, module: :questions
    resources :answers, shallow: true do 
      concerns :attachable
      concerns :voteable
      resources :comments, module: :answers
      patch :set_best, on: :member
    end
  end

  resources :links, only: :destroy
  resources :awards, only: :index

  mount ActionCable.server => '/cable'
end
