class AddColumnToJob < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :rental, :string
  end
end
