Rails.application.routes.draw do
  resources :comments, only: [:create, :edit, :update, :destroy]
  resources :posts
  devise_for :users

  root to: "posts#index"
end
