class Worker < ApplicationRecord
  belongs_to :user
  has_many :progresses
  has_many :offers
  #mount_uploader :voice_data, VoiceUploader
  #mount_uploader :identification, UploadFileUploader
end
