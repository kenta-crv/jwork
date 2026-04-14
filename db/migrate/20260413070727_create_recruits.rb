class CreateRecruits < ActiveRecord::Migration[5.2]
  def change
    create_table :recruits do |t|
      t.string :title
      t.string :description
      t.string :unit_price
      t.string :reward
      t.string :working_hours
      t.string :working_days
      t.string :area
      t.string :payment
      t.string :japanese_skill
      t.string :require
      t.string :contract_type
      t.string :car_details
      t.string :remarks
      t.timestamps
    end
  end
end
