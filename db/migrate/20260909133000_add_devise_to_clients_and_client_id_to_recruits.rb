class AddDeviseToClientsAndClientIdToRecruits < ActiveRecord::Migration[6.1]
  def change
    change_table :clients, bulk: true do |t|
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
    end

    # 既存データに email 重複があるため unique index は付けない
    add_index :clients, :reset_password_token, unique: true

    add_reference :recruits, :client, foreign_key: true, null: true
  end
end
