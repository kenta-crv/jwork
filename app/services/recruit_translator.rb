# frozen_string_literal: true

# 日本語で入力された Recruit の本文を DeepL で英訳し、*_en カラムへ保存する。
class RecruitTranslator
  TRANSLATABLE_ATTRIBUTES = %w[
    title description unit_price reward working_hours working_days
    area payment japanese_skill require contract_type car_details
    remarks recommend
  ].freeze

  VISA_EN = {
    "日本国籍" => "Japanese nationality",
    "永住ビザ" => "Permanent resident visa",
    "長期滞在ビザ" => "Long-term resident visa",
    "定住ビザ" => "Teijusha (long-term resident) visa",
    "難民ビザ" => "Refugee visa",
    "家族滞在ビザ" => "Dependent visa",
    "留学ビザ" => "Student visa"
  }.freeze

  JA_CHAR = /[\p{Hiragana}\p{Katakana}\p{Han}]/

  def self.apply!(recruit)
    new(recruit).apply!
  end

  def initialize(recruit)
    @recruit = recruit
  end

  def apply!
    sync_visa_en
    sync_text_fields
  end

  private

  attr_reader :recruit

  def sync_visa_en
    return unless recruit.visa_changed? || recruit.new_record? || recruit.visa_en.blank?

    recruit.visa_en = Array(recruit.visa).map { |v| VISA_EN[v] || v }
  end

  def sync_text_fields
    targets = TRANSLATABLE_ATTRIBUTES.select { |attr| needs_translation?(attr) }
    return if targets.empty?
    return skip_without_api_key if auth_key.blank?

    texts = targets.map { |attr| recruit.public_send(attr).to_s }
    translated = translate_batch(texts)

    targets.each_with_index do |attr, i|
      recruit.public_send("#{attr}_en=", translated[i])
    end
  end

  def skip_without_api_key
    Rails.logger.warn("[RecruitTranslator] DEEPL_AUTH_KEY が未設定のため英訳をスキップしました")
  end

  def needs_translation?(attr)
    en_attr = "#{attr}_en"
    value = recruit.public_send(attr)

    if value.blank?
      recruit.public_send("#{en_attr}=", nil) if recruit.public_send(en_attr).present?
      return false
    end

    recruit.new_record? ||
      recruit.public_send("#{attr}_changed?") ||
      recruit.public_send(en_attr).blank?
  end

  def translate_batch(texts)
    return texts.map { |t| fallback_text(t) } if auth_key.blank?

    indexed = []
    payload = []

    texts.each_with_index do |text, i|
      if text.match?(JA_CHAR)
        indexed << i
        payload << text
      end
    end

    result = texts.dup
    return result if payload.empty?

    translated = call_deepl(payload)
    indexed.each_with_index do |original_index, j|
      result[original_index] = translated[j].presence || fallback_text(texts[original_index])
    end
    result
  rescue => e
    Rails.logger.warn("[RecruitTranslator] #{e.class}: #{e.message}")
    texts.map { |t| fallback_text(t) }
  end

  def call_deepl(texts)
    body = URI.encode_www_form(
      [
        ["source_lang", "JA"],
        ["target_lang", "EN-US"]
      ] + texts.map { |t| ["text", t] }
    )

    response = Faraday.post(api_url) do |req|
      req.headers["Authorization"] = "DeepL-Auth-Key #{auth_key}"
      req.headers["Content-Type"] = "application/x-www-form-urlencoded"
      req.body = body
      req.options.timeout = 20
      req.options.open_timeout = 5
    end

    unless response.success?
      raise "DeepL API error #{response.status}: #{response.body.to_s.truncate(200)}"
    end

    json = JSON.parse(response.body)
    translations = Array(json["translations"])
    raise "DeepL response size mismatch" if translations.size != texts.size

    translations.map { |row| row["text"] }
  end

  def fallback_text(text)
    text
  end

  def auth_key
    ENV["DEEPL_AUTH_KEY"].to_s.strip.presence
  end

  def api_url
    host = ENV.fetch("DEEPL_API_HOST", "api-free.deepl.com")
    "https://#{host}/v2/translate"
  end
end
