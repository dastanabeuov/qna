require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  get :search, to: 'search#index'

  use_doorkeeper
  root to: "questions#index"

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  concern :voteable do
    post :like, :dislike, on: :member
  end
  
  resources :questions, concerns: %i[voteable], shallow: true do
    resources :attachments, shallow: true, only: %i[destroy]
    resources :comments, only: %i[create]
    resources :subscriptions, only: %i[create destroy], shallow: true
    
    resources :answers, concerns: %i[voteable] do
      patch :set_best, on: :member
      resources :attachments, shallow: true, only: %i[destroy]
      resources :comments, only: %i[create]
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create], shallow: true do
        resources :answers, only: %i[index show create]
      end
    end
  end

  resources :links, only: :destroy
  resources :awards, only: :index

  mount ActionCable.server => '/cable'
end
