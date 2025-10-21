class AddColumnToUsers3 < ActiveRecord::Migration[5.2]
  def change
        add_column :users, :contract_date, :string 
  end
end
