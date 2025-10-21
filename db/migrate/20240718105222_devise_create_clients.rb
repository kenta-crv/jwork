# frozen_string_literal: true

class DeviseCreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      ## Database authenticatable
      t.string :user_name,          null: false, default: ""
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      #問い合わせ項目
      t.string :company #会社名
      t.string :post_title #代表取締役
      t.string :representative_name #代表者
      #t.string :representative_kana #代表者
      t.string :contact_name #担当者
      #t.string :contact_kana #担当者
      t.string :tel #携帯番号
      t.string :email #メールアドレス
      t.string :address #求人所在地
      t.string :url #企業URL
      t.string :message #備考
      #自社入力
      t.string :recruit_url #求人URL
      t.string :visa #必要なVISA
      t.string :business #募集業種
      t.string :genre #募集職種
      t.string :salary #給料条件
      t.string :work_time #勤務時間
      t.string :day_off #休日
      t.string :work_contents #業務内容
      t.string :number #採用人数
      t.string :house_agents #自宅契約サポート
      t.string :house_support #住居サポート
      t.string :remarks #備考
      #契約情報

      t.string :agree #契約同意
      t.string :contract_date #契約日

      t.string :plan1 
      t.string :plan2 
      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :clients, :email,                unique: true
    add_index :clients, :reset_password_token, unique: true
    # add_index :clients, :confirmation_token,   unique: true
    # add_index :clients, :unlock_token,         unique: true
  end
end
