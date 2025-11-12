class CreateAddColumnToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :rental, :string
  end
end
