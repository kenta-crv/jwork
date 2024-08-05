class CreateProgresses < ActiveRecord::Migration[5.2]
  def change
    create_table :progresses do |t|
      t.string :status
      t.string :next
      t.string :body
      t.references :worker, foreign_key: true
      t.timestamps
      t.timestamps
    end
  end
end
