# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :user_name,          null: false, default: ""
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip
      t.string  :name #名前
      t.string  :tel #電話番号
      t.string  :age #生年月日
      t.string  :email #メールアドレス
      t.string  :nationality #国籍
      t.string  :past_business #業種
      t.string  :past_genre #職種
      t.string  :past_year #年数 _ 
      t.string  :qualifications #資格
      t.string  :work_range #働ける範囲（visa）
      t.string  :hope_work #希望職種
      t.string  :hope_other #その他希望
      t.string  :line #ライン登録
      t.string  :period #何ヶ月以内
      t.string  :recommend #オススメ度
      t.string  :remarks #備考

      t.string  :conversation #会話
      t.string  :resume #履歴書
      t.string  :available #対応可能時間
      t.string  :different #違う時間

      t.string  :call_check #日本語チェック
      t.string  :call_impressions #電話の印象
      t.string  :change_the_address #都道府県変更
      t.string  :call_available #電話可能時間
      t.string  :speak_japanese #日本語会話
      t.string  :gender #性別
      t.string  :drivers_lisence 
      t.string  :car 
      t.string  :address 
      t.string  :change_the_address_check
      t.string  :work_now
      t.string  :experience
      t.string  :which_visa
      t.string  :japanese_level    
      t.string  :visiting_in_japan  
      t.string  :kanzi  
      t.string  :start
    # Users 
      t.string  :address_detail    
      t.string  :drivers_up    
      t.string  :emergency_name  
      t.string  :emergency_relationships 
      t.string  :emergency_tel   
    # Users
      t.string  :agree  
      t.string  :check_1  
      t.string  :check_2  
      t.string  :check_3  
      t.string  :check_4  
      t.string  :check_5  
      t.string  :check_6  
      t.string  :check_7  
    
      t.string  :deliver  
      t.string  :day_off  
      t.string  :contract_date 
  end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
