class Recruit < ApplicationRecord
  belongs_to :client, optional: true
  has_many :recruit_saves, class_name: "RecruitSave", dependent: :destroy, inverse_of: :recruit

  serialize :visa, Array
  serialize :visa_en, Array

  before_save :translate_japanese_fields_to_english

  def text_for(attr)
    public_send("#{attr}_en").presence || public_send(attr)
  end

  def visa_for_display
    Array(visa_en.presence || visa)
  end

  def saved_by?(visitor_token)
    return false if visitor_token.blank?

    recruit_saves.exists?(visitor_token: visitor_token)
  end

  private

  def translate_japanese_fields_to_english
    RecruitTranslator.apply!(self)
  end
end
