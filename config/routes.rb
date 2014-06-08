Rails.application.routes.draw do




  resources :comments, except: [:new, :create] do
    resources :comments, only: [:new, :create, :show]
    member do
      post "upvote"
      post "downvote"
    end
  end

  resources :links, only: [:edit, :update, :show, :destroy, :index] do
    resources :comments, only: [:new, :create, :show]
    member do
      post "upvote"
      post "downvote"
    end

  end


  resources :subs do
    resources :links, only: [:new, :create]
  end

  resources :users, only: [:new, :create, :show]
  resource :session, only: [:new, :create, :destroy]

  root to: "sessions#new"
end
