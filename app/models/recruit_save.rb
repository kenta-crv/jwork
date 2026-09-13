class RecruitSave < ApplicationRecord
  belongs_to :recruit, counter_cache: :saves_count, inverse_of: :recruit_saves

  validates :visitor_token, presence: true
  validates :recruit_id, uniqueness: { scope: :visitor_token }
end
