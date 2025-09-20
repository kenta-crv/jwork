class CreateRecruits < ActiveRecord::Migration[5.2]
  def change
    create_table :recruits do |t|
      t.string :title
      t.string :work_contents
      t.string :salary
      t.string :genre
      t.string :work_time
      t.string :work_time_total
      t.string :day_off
      t.string :address
      t.string :traning
      t.string :qualification_1
      t.string :qualification_2
      t.timestamps
    end
  end
end
