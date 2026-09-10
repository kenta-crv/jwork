class Recruit < ApplicationRecord
  belongs_to :client, optional: true

  serialize :visa, Array
  serialize :visa_en, Array

  before_save :translate_japanese_fields_to_english

  def text_for(attr)
    public_send("#{attr}_en").presence || public_send(attr)
  end

  def visa_for_display
    Array(visa_en.presence || visa)
  end

  private

  def translate_japanese_fields_to_english
    RecruitTranslator.apply!(self)
  end
end
