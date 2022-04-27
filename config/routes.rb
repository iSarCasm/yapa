Rails.application.routes.draw do
  resources :posts do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end
  devise_for :users

  root to: "posts#index"
end
