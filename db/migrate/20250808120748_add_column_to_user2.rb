class AddColumnToUser2 < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :call_check, :string #日本語チェック
    add_column :users, :call_impressions, :string #電話の印象
    add_column :users, :change_the_address, :string #都道府県変更
    add_column :users, :call_available, :string #電話可能時間
    add_column :users, :speak_japanese, :string #日本語会話
    add_column :users, :gender, :string #性別
  end
end
