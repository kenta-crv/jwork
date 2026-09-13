class AddRecruitEngagementMetrics < ActiveRecord::Migration[6.1]
  def change
    add_column :recruits, :views_count, :integer, null: false, default: 0
    add_column :recruits, :applications_count, :integer, null: false, default: 0
    add_column :recruits, :saves_count, :integer, null: false, default: 0

    create_table :recruit_saves do |t|
      t.references :recruit, null: false, foreign_key: true
      t.string :visitor_token, null: false
      t.timestamps
    end

    add_index :recruit_saves, [:visitor_token, :recruit_id], unique: true
    add_index :recruit_saves, :visitor_token
  end
end
