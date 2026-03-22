class AddNextCallAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :next_call_at, :date
  end
end
