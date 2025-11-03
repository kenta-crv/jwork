class CreateInspections < ActiveRecord::Migration[5.2]
  def change
    create_table :inspections do |t|
      t.datetime :post
      t.string :brakes
      t.string :steering
      t.string :tires
      t.string :lighting
      t.string :battely
      t.string :engine
      t.string :coolant
      t.string :wiper
      t.string :exhaust
      t.string :underbody
      t.string :remarks
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
