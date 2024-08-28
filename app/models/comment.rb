class Comment < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :client, dependent: :destroy
end
