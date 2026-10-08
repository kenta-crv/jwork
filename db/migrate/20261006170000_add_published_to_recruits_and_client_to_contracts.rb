class AddPublishedToRecruitsAndClientToContracts < ActiveRecord::Migration[6.1]
  def up
    add_column :recruits, :published, :boolean, default: false, null: false
    add_reference :contracts, :client, foreign_key: { on_delete: :nullify }, null: true

    Recruit.reset_column_information
    Recruit.where.not(point: nil).where.not(point: 0).update_all(published: true)
  end

  def down
    remove_reference :contracts, :client, foreign_key: true
    remove_column :recruits, :published
  end
end
