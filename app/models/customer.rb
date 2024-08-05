class Customer < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :client
  has_many :offers
end
