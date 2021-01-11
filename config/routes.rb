Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"
  
  resources :questions do
    patch :like, on: :member
    patch :dislike, on: :member    
    resources :comments, module: :questions

    resources :answers, shallow: true do 
      patch :set_best, on: :member
      patch :like, on: :member
      patch :dislike, on: :member
      resources :comments, module: :answers
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

  mount ActionCable.server => '/cable'
end
