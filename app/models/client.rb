class Client < ApplicationRecord
    has_many :jobs
    has_many :situations
end
