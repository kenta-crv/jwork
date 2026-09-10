class AddEnglishColumnsToRecruits < ActiveRecord::Migration[6.1]
  def change
    change_table :recruits, bulk: true do |t|
      t.text :title_en
      t.text :description_en
      t.text :unit_price_en
      t.text :reward_en
      t.text :working_hours_en
      t.text :working_days_en
      t.text :area_en
      t.text :payment_en
      t.text :japanese_skill_en
      t.text :require_en
      t.text :contract_type_en
      t.text :car_details_en
      t.text :remarks_en
      t.text :recommend_en
      t.text :visa_en
    end
  end
end
