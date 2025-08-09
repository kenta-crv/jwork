class AccessLog < ApplicationRecord
  belongs_to :top, optional: true
end
