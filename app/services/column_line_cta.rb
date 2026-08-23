# frozen_string_literal: true

# J Work 側で管理する Column 記事下部の LINE 導線。
# drafity のコードは変更しない。
#
# 優先順位:
# 1. 明示の sub_genre パラメータ（将来用）
# 2. config/column_line_cta.yml の code 一覧
# 3. デフォルト delivery_partner（Amazon外国人配送・企業）
class ColumnLineCta
  CTAS = {
    "delivery_partner" => {
      kind: "business",
      badge: "法人向け",
      title: "新規取引のご相談はLINEで",
      lead: "Amazon配送の外国人材確保・業務請負について、まずはお気軽にご相談ください。",
      cta_label: "新規取引相談",
      url: "https://lin.ee/NZBWRrsD",
      qr_url: "https://qr-official.line.me/gs/M_697qedfz_GW.png?oat_content=qr",
      banner_path: "/images/line-cta-business.webp"
    },
    "foreign_hiring" => {
      kind: "business",
      badge: "企業向け",
      title: "外国人雇用のご相談はLINEで",
      lead: "採用・受け入れ・求人掲載についてご案内します。",
      cta_label: "雇用の相談",
      url: "https://lin.ee/NZBWRrsD",
      qr_url: "https://qr-official.line.me/gs/M_697qedfz_GW.png?oat_content=qr",
      banner_path: "/images/line-cta-business.webp"
    },
    "driver_recruitment" => {
      kind: "recruit",
      badge: "求職者向け",
      title: "お仕事の応募はLINEで",
      lead: "日本でのお仕事情報をLINEで受け取れます。未経験の方も歓迎です。",
      cta_label: "お仕事の応募",
      url: "https://lin.ee/8pGADE1",
      qr_url: "https://qr-official.line.me/gs/M_522jmsbm_GW.png?oat_content=qr",
      banner_path: "/images/line-cta-recruit.webp"
    },
    "life_guide" => {
      kind: "recruit",
      badge: "生活サポート",
      title: "仕事と暮らしの相談はLINEで",
      lead: "役所の手続きで困ったときも、求人情報もLINEで案内します。",
      cta_label: "相談する",
      url: "https://lin.ee/8pGADE1",
      qr_url: "https://qr-official.line.me/gs/M_522jmsbm_GW.png?oat_content=qr",
      banner_path: "/images/line-cta-recruit.webp"
    },
    "specified_skills" => {
      kind: "business",
      badge: "企業向け",
      title: "特定技能・技能実習の相談はLINEで",
      lead: "受け入れの流れと、現場人材のご案内をします。",
      cta_label: "受け入れの相談",
      url: "https://lin.ee/NZBWRrsD",
      qr_url: "https://qr-official.line.me/gs/M_697qedfz_GW.png?oat_content=qr",
      banner_path: "/images/line-cta-business.webp"
    },
    "support_orgs" => {
      kind: "business",
      badge: "支援団体向け",
      title: "団体掲載・連携はLINEで",
      lead: "プロフィール掲載や、企業・求職者との橋渡しをご相談ください。",
      cta_label: "連携の相談",
      url: "https://lin.ee/NZBWRrsD",
      qr_url: "https://qr-official.line.me/gs/M_697qedfz_GW.png?oat_content=qr",
      banner_path: "/images/line-cta-business.webp"
    },
    "labor_help" => {
      kind: "recruit",
      badge: "相談窓口",
      title: "困ったときの窓口案内はLINEで",
      lead: "未払い・ハラスメントは公的窓口が本筋です。行き先が分からない場合にご案内します。",
      cta_label: "窓口を聞く",
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
