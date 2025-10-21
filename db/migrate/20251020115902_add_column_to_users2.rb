class AddColumnToUsers2 < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :deliver, :string  
    add_column :users, :day_off, :string 
  end
end
