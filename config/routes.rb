Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"
  
  resources :questions do
    resources :answers, shallow: true do
      patch :correct_best, on: :member
    end
  end

  resources :attachments, only: %i[destroy]
  resources :links, only: :destroy
end
