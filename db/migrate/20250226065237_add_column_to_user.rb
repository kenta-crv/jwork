class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :conversation, :string #会話
    add_column :users, :resume, :string #履歴書
    add_column :users, :available, :string #対応可能時間
    add_column :users, :different, :string #違う時間
  end
end
