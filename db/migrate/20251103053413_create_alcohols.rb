class CreateAlcohols < ActiveRecord::Migration[5.2]
  def change
    create_table :alcohols do |t|
      t.datetime :post
      t.string :check
      t.string :health
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
