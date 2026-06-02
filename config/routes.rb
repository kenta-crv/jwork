Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  # トップページ
  root to: 'top#index'

  get "top/recruit" => 'top#recruit'  # クライアント側トップ
  get "top/recruit_jp" => 'top#recruit_jp'  # クライアント側トップ
  get "top/recruit_en" => 'top#recruit_en'  # クライアント側トップ
  get "top/recruit_clean" => 'top#recruit_clean'  # クライアント側トップ
  get "top/calculation" => 'top#calculation'  

  get "top/start" => 'top#start'  

  get 'information' => 'top#information' #社外周知
  
  get "top/flow" => 'top#flow'
  get "top/entry" => 'top#entry'
  get "top/attention" => 'top#attention'  
  get "top/apply" => 'top#apply'  
  get "top/black" => 'top#black'

  get "top/policy" => 'top#policy'  


  #get "/database" => 'top#database' # ユーザー側トップ
  get '/redirect', to: 'top#redirect'
  get 'users/thanks', to: 'users#thanks'
  get 'lp', to: 'top#lp'
   
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
end
