Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: 'top#index' # クライアント側トップ
  get "/appointer" => 'top#appointer' # ユーザー側トップ
  get "/database" => 'top#database' # ユーザー側トップ
  get "/zero" => 'top#zero' # ユーザー側トップ
  get "/free" => 'top#free' # ユーザー側トップ
  get "/restaurant" => 'top#restaurant' # ユーザー側トップ
  get '/redirect', to: 'top#redirect'
  get 'users/thanks', to: 'users#thanks'
  get 'documents', to: 'top#documents'
  get 'databases', to: 'top#databases'
  get 'lp', to: 'top#lp'
  resources :access_logs, only: [:index]
   
  get 'line', to: 'top#line'

  # 管理者アカウント
  devise_for :admins, controllers: {
    registrations: 'admins/registrations',
    sessions: 'admins/sessions'
  }
  resources :admins, only: [:show]

  resources :contracts do
    #resource :comments
    collection do
      post :confirm
      post :thanks
    end
    member do
      post :send_mail
      get "info" #案内
      get "conclusion"
    end
  end

  #get  '/clients/new', to: 'clients#new',    as: :new_client
  #post '/clients',     to: 'clients#create', as: :clients
  #get '/clients/thanks', to: 'clients#thanks', as: :thanks_clients

  # クライアントアカウント
  devise_for :clients, controllers: {
    registrations: 'clients/registrations',
    sessions: 'clients/sessions',
    passwords: 'clients/passwords'
  }
  resources :clients, except: [:new, :create] do
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
      get "conclusion"
    end
  end

    #加盟店先アカウント
    devise_for :partners, controllers: {
      registrations: 'partners/registrations',
      sessions: 'partners/sessions'
    }
    resources :partners do
      member do
        post :disclose
        post :send_mail
        post :send_mail_start #開始日の送信
        get "conclusion"
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
