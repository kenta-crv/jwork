class Offer < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :client, optional: true
  validates :message, length: { minimum: 50, message: 'は50文字以上で入力してください' }
end
