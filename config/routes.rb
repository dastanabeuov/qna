Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"
  
  resources :questions do
    patch :like, on: :member
    patch :dislike, on: :member    
    resources :answers, shallow: true do 
      patch :correct_best, on: :member

      patch :like, on: :member
      patch :dislike, on: :member      
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index
end
