Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"
  
  resources :questions do
    member do
      delete :delete_file_attachment
    end  	
    resources :answers, shallow: true do
	    member do
	      delete :delete_file_attachment
	    end    	
      patch :correct_best, on: :member
    end
  end
end
