Rails.application.routes.draw do
  root to: 'top#index' # クライアント側トップ
  get "/appointer" => 'top#appointer' # ユーザー側トップ
  
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
  resources :clients do
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
  resources :users do
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
      post 'offer_email', to: 'workers#offer_email', as: 'offer_email'
      post 'reject_email', to: 'workers#reject_email', as: 'reject_email'
   end
  end

  resources :offers, only: [:index, :show]
end
