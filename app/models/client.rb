class Client < ApplicationRecord
  has_many :jobs, dependent: :destroy
  has_many :situations, dependent: :destroy
end
