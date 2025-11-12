class CreateAddColumnToClients < ActiveRecord::Migration[5.2]
  def change
    create_table :add_column_to_clients do |t|
      add_column :clients, :rental, :string
      t.timestamps
    end
  end
end
