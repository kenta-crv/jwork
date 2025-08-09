class Top < ApplicationRecord
    has_many :access_logs, dependent: :destroy
end
