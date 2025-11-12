class CreateSituations < ActiveRecord::Migration[5.2]
  def change
    create_table :situations do |t|
      t.string :status
      t.string :next
      t.string :body
      t.references :client, foreign_key: true
      t.timestamps
    end
  end
end
