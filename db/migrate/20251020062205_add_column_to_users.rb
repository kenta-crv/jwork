class AddColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :drivers_lisence, :string 
    add_column :users, :car, :string 
    add_column :users, :address, :string 
    add_column :users, :change_the_address_check, :string
    add_column :users, :work_now, :string
    add_column :users, :experience, :string
    add_column :users, :which_visa, :string
    add_column :users, :japanese_level, :string    
    add_column :users, :visiting_in_japan, :string  
    add_column :users, :kanzi, :string  
    add_column :users, :start, :string
    # Users 
    add_column :users, :address_detail, :string    
    add_column :users, :drivers_up, :string    
    add_column :users, :emergency_name, :string  
    add_column :users, :emergency_relationships, :string 
    add_column :users, :emergency_tel, :string   
    # Users
    add_column :users, :agree, :string  
    add_column :users, :check_1, :string  
    add_column :users, :check_2, :string  
    add_column :users, :check_3, :string  
    add_column :users, :check_4, :string  
    add_column :users, :check_5, :string  
    add_column :users, :check_6, :string  
    add_column :users, :check_7, :string   
  end
end
