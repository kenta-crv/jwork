class AddColumnToUser2 < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :image_5, :string
    add_column :users, :image_6, :string
    add_column :users, :bank, :string
    add_column :users, :branch, :string
    add_column :users, :bank_number, :string
    add_column :users, :bank_name, :string
  end
end
