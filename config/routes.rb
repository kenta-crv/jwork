Rails.application.routes.draw do
  root to: 'top#index' # クライアント側トップ
  #root to: 'top#appointer' # ユーザー側トップ

  # 管理者アカウント
  devise_for :admins, controllers: {
    registrations: 'admins/registrations',
    sessions: 'admins/sessions'
  }
  resources :admins, only: [:show]

  # クライアントアカウント
  devise_for :clients, controllers: {
    registrations: 'clients/registrations',
    sessions: 'clients/sessions'
  }
  resources :clients, only: [:show, :destroy] do
    resource :customer, only: [:new, :create, :show]
  end

  # 顧客リソースとオファーのルーティング
  resources :customers do
    resources :offers do
      member do
        get 'confirm'
        post 'thanks'
      end
    end
    resource :comments
    collection do
      post :confirm
      post :thanks
    end
    member do
      post :send_mail
      post :send_mail_start
      get "info"
      get "conclusion"
      get "payment"
      get "calendar"
      get "start"
    end
  end

  # ユーザーアカウントとワーカーリソース
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :users, only: [:show, :destroy] do
    resource :worker, only: [:new, :create, :show] 
  end

  resources :workers do
    #resources :orders do
    resources :offers do
      member do
        get 'confirm'
        post 'thanks'
      end
    end
    resources :progresses
    collection do
      post 'confirm'
      post 'thanks'
      get 'second_thanks'
    end
    member do
      post 'offer_email', to: 'workers#offer_email', as: 'offer_email'
      post 'reject_email', to: 'workers#reject_email', as: 'reject_email'
    end
  end

  resources :offers, only: [:index, :show]
  resources :orders, only: [:index, :show, :create]
end
