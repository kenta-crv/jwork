class AddPlanToClient < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :plan1, :string 
    add_column :clients, :plan2, :string 
  end
end
