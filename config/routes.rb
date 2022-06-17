Rails.application.routes.draw do
  resources :users, only: [:new, :create]
  resources :pictures do
    collection do
      post :confirm
    end
  end
end
