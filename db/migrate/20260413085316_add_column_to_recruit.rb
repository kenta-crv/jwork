class AddColumnToRecruit < ActiveRecord::Migration[5.2]
  def change
    add_column :recruits, :recommend, :string
    add_column :recruits, :point, :integer
    add_column :recruits, :genre, :string
    add_column :recruits, :visa, :string
  end
end
