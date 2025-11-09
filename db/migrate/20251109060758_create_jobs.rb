class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.string :content
      t.string :working_time
      t.string :area
      t.string :purchase_price
      t.string :sales_price
      t.string :delivery
      t.string :payment
      t.string :remarks
      t.references :client, foreign_key: true
      t.timestamps
    end
  end
end
