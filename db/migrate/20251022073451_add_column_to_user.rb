class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :account_name, :string
    add_column :users, :image_1, :string
    add_column :users, :image_2, :string
    add_column :users, :image_3, :string
    add_column :users, :image_4, :string
  end
end
