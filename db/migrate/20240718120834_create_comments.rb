class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :status
      t.string :next
      t.string :body
      t.references :user, foreign_key: true
      t.references :client, foreign_key: true
      t.timestamps
    end
  end
end
