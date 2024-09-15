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
      t.string  :name
      t.string  :age
      t.string  :email
      t.string  :nationality #国籍
      t.string  :past_business #業種
      t.string  :past_genre #職種
      t.string  :past_year #年数
      t.string  :qualifications #資格
      t.string  :work_range #働ける範囲
      t.string  :hope_work #希望職種
      t.string  :hope_other #その他希望
      t.string  :line #ライン登録
      t.string  :period #何ヶ月以内
      t.string  :recommend #オススメ度
      t.string  :remarks #備考

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
