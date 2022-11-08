Rails.application.routes.draw do

  devise_for :users, controllers:{
    registrations: "public/registrations",
    sessions: 'public/sessions',
    passwords: 'public/passwords'
  }

  devise_scope :user do
    post '/users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  scope module: :public do
    root 'homes#top'
    get 'users/mypage' => 'users#index', as: 'mypage'
    get 'users/information/edit' => 'users#edit', as: 'edit_information'
    patch 'users/information' => 'users#update', as: 'update_information'
    resources :posts, only: [:new, :create, :show, :index, :edit, :update, :destroy] do
      resources :comments,  only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
  end
    resources :users, only: [:show]do
    resources :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  end

  devise_for :admin,skip:[:registrations, :passwords], controllers:{
    sessions: "admin/sessions"
  }

  namespace :admin do
    get 'top' => 'homes#top', as: 'top'
    resources :users, only: [:index, :show, :edit, :update]
    resources :posts, only: [:index, :show]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
