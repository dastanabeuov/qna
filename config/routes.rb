Rails.application.routes.draw do
  root to: "questions#index"

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  concern :attachable do
    resources :attachments, shallow: true, only: %i[destroy]
  end

  concern :voteable do
    post :like, :dislike, on: :member
  end

  concern :commentable do
    resources :comments
  end  
  
  resources :questions, concerns: %i[voteable attachable commentable], shallow: true do
    resources :answers, concerns: %i[voteable attachable commentable] do
      patch :set_best, on: :member
    end
  end

  resources :links, only: :destroy
  resources :awards, only: :index

  mount ActionCable.server => '/cable'
end
