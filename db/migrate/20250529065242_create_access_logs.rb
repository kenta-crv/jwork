class CreateAccessLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :access_logs do |t|
      t.string :source
      t.string :path
      t.string :ip
      t.datetime :accessed_at

      t.timestamps
    end
  end
end
