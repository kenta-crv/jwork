Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: 'top#index' # クライアント側トップ
  get "top/recruit" => 'top#recruit'  # クライアント側トップ
  get "top/recruit_jp" => 'top#recruit_jp'  # クライアント側トップ
  get "top/recruit_en" => 'top#recruit_en'  # クライアント側トップ
  get "top/recruit_clean" => 'top#recruit_clean'  # クライアント側トップ
  get "top/calculation" => 'top#calculation'  

  get 'information' => 'top#information' #社外周知

  
  get "top/flow" => 'top#flow'
  get "top/entry" => 'top#entry'
  get "top/attention" => 'top#attention'  
  get "top/apply" => 'top#apply'  
  get "top/black" => 'top#black'

  get "top/policy" => 'top#policy'  

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
    resources :journals
    resources :alcohols
    resources :inspections
    collection do
      post :bulk_call_ivr # 一括発信用
      get :call
      post :confirm
      post :thanks
    end
    member do
      post :send_sms
      post :send_mail
      post :send_mail_start
      get "info"
      get "conclusion"
      get "payment"
      get "calendar"
      get "start"
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
end
