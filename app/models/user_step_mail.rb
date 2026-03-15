# app/models/user_step_mail.rb
class UserStepMail < ApplicationRecord
  belongs_to :user
  # status の enum は削除するか無視してOK
end