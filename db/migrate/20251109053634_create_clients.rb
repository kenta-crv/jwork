class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :company
      t.string :position
      t.string :person
      t.string :tel 
      t.string :email
      t.string :mobile
      t.string :address
      t.string :url
      t.datetime :meeting
      t.string :remarks
      t.timestamps
    end
  end
end
