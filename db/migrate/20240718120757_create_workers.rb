class CreateWorkers < ActiveRecord::Migration[5.2]
  def change
    create_table :workers do |t|
    t.string  :name
    t.string  :age
    t.string  :email
    t.string  :experience
    t.string  :voice_data
    t.string  :year
    t.string  :commodity
    t.string  :hope
    t.string  :period
    t.string  :pc
    t.string  :start
    t.string  :tel
    t.string  :agree_1
    t.string  :agree_2
    t.string  :emergency_name
    t.string  :emergency_relationship
    t.string  :emergency_tel
    t.string  :identification
    t.string  :bank
    t.string  :branch
    t.string  :bank_number
    t.string  :bank_name
    t.string  :status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
