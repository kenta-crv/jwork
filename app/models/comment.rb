class Comment < ApplicationRecord
    belongs_to :customer, dependent: :destroy
end
