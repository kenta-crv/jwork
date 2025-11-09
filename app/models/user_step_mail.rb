class UserStepMail < ApplicationRecord
  belongs_to :user

  enum status: { pending: "pending", sent: "sent", failed: "failed" }
end
