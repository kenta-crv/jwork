class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :client, foreign_key: true
      t.references :user, foreign_key: true
      t.references :customer, foreign_key: true
      t.references :worker, foreign_key: true
      t.text :message
      t.timestamps
    end
  end
end
