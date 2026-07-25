# frozen_string_literal: true

# J Work 側で管理する Column 記事下部の LINE 導線。
# drafity のコードは変更しない。
#
# 優先順位:
# 1. 明示の sub_genre パラメータ（将来用）
# 2. config/column_line_cta.yml の code 一覧
# 3. デフォルト delivery_partner（新規取引相談）
class ColumnLineCta
  CTAS = {
    "delivery_partner" => {
      kind: "business",
      badge: "法人向け",
      title: "新規取引のご相談はLINEで",
      lead: "Amazon配送の人材確保・業務請負について、まずはお気軽にご相談ください。",
      cta_label: "新規取引相談",
      url: "https://lin.ee/NZBWRrsD",
      qr_url: "https://qr-official.line.me/gs/M_697qedfz_GW.png?oat_content=qr",
      banner_path: "/images/line-cta-business.webp"
    },
    "driver_recruitment" => {
      kind: "recruit",
      badge: "求職者向け",
      title: "お仕事の応募はLINEで",
      lead: "Amazon配送ドライバーのお仕事情報をLINEで受け取れます。未経験の方も歓迎です。",
      cta_label: "お仕事の応募",
      url: "https://lin.ee/8pGADE1",
      qr_url: "https://qr-official.line.me/gs/M_522jmsbm_GW.png?oat_content=qr",
      banner_path: "/images/line-cta-recruit.webp"
    }
  }.freeze

  def self.resolve(code: nil, sub_genre: nil)
    key = sub_genre.to_s
    return for_sub_genre(key) if CTAS.key?(key)

    code_str = code.to_s
    return for_sub_genre("driver_recruitment") if code_str != "" && recruit_codes.include?(code_str)

    for_sub_genre(default_sub_genre)
  end

  def self.for_sub_genre(sub_genre)
    key = sub_genre.to_s
    key = "delivery_partner" unless CTAS.key?(key)
    CTAS[key]
  end

  def self.default_sub_genre
    value = config["default_sub_genre"].to_s
    value.empty? ? "delivery_partner" : value
  end

  def self.recruit_codes
    Array(config["driver_recruitment_codes"]).map(&:to_s)
  end

  def self.config
    path = Rails.root.join("config/column_line_cta.yml")
    return {} unless File.exist?(path)

    raw = YAML.safe_load(File.read(path), permitted_classes: [], aliases: false)
    raw.is_a?(Hash) ? raw : {}
  rescue StandardError
    {}
  end
end
