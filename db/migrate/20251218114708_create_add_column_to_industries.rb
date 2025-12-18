class CreateAddColumnToIndustries < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :industry, :string
  end
end
