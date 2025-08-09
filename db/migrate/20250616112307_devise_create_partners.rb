# frozen_string_literal: true

class DeviseCreatePartners < ActiveRecord::Migration[5.2]
  def change
    create_table :partners do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

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
      #契約情報

      t.string :agree #契約同意
      t.string :contract_date #契約日
      
      # ヒアリングフォーム
      t.string  :question_people            # 毎月の人材紹介数
      t.string  :question_attractive        # 主な取引先の集客方法
      t.string  :question_open              # 取引先情報の開示
      t.string  :question_prediction        # 本サービスの月の利用想定人数

      # 同意条項
      t.string  :agree_1
      t.string  :agree_2
      t.string  :agree_3
      t.string  :agree_4
      t.string  :agree_5
      t.string  :agree_6
      t.string  :agree_7


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

    add_index :partners, :email,                unique: true
    add_index :partners, :reset_password_token, unique: true
    # add_index :partners, :confirmation_token,   unique: true
    # add_index :partners, :unlock_token,         unique: true
  end
end
