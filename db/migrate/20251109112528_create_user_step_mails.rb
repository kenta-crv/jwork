class CreateUserStepMails < ActiveRecord::Migration[5.2]
  def change
    create_table :user_step_mails do |t|
      t.references :user, foreign_key: true
      t.string :mail_type
      t.datetime :scheduled_at
      t.datetime :sent_at
      t.string :status

      t.timestamps
    end
  end
end
