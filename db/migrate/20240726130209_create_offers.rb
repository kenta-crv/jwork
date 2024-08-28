class CreateOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :offers do |t|
      t.references :client, foreign_key: true
      t.references :user, foreign_key: true
      t.text :message
      t.timestamps
    end
  end
end
