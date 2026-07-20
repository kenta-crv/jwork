Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  # トップページ
  root to: 'top#index'

  get "top/policy" => 'top#policy'

  get '/redirect', to: 'top#redirect'
  get 'users/thanks', to: 'users#thanks'
  get 'line', to: 'top#line'

  # 管理者アカウント
  devise_for :admins, controllers: {
    registrations: 'admins/registrations',
    sessions: 'admins/sessions'
  }
  resources :admins, only: [:show]


  resources :clients do
    resources :situations
    resources :jobs 
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

  # ユーザーアカウントとワーカーリソース
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :users do
    resources :comments
    collection do
      post :bulk_call_ivr # 一括発信用
      get :call
      post :confirm
      post :thanks
      post :bulk_sms
    end
    member do
      post :send_sms
      post :send_mail
      post :send_mail_start
      get "info"
      get "conclusion"
      get "payment"
      get "calendar"
      #get "start"
      post :call_ivr
      match 'show_ivr', to: 'ivr#show', as: :show_ivr, via: [:get, :post]
      post 'handle_choice_ivr', to: 'ivr#handle_choice', as: :handle_choice_ivr
    end
  end
  post "/api/v1/users/from_sheet", to: "api/v1/users#sheet_create"

  resources :ivr, only: [] do
   member do
    get :show      # 初期質問
    post :handle_choice  # 選択の受信
   end
  end

  resources :recruits
  #get 'columns',         to: 'top#columns'

  get '/pages/cargo',    to: 'pages#cargo'
  get '/pages/human',    to: 'pages#human'
  get '/pages/event',    to: 'pages#event'
  get '/pages/cleaning', to: 'pages#cleaning'
  get '/pages/logistic', to: 'pages#logistics'

  resources :contracts
end
