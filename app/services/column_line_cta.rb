# frozen_string_literal: true

# J Work 側で管理する Column 記事下部の LINE 導線。
# nil / delivery_partner → 新規取引相談
# driver_recruitment → お仕事の応募
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

  def self.for_sub_genre(sub_genre)
    key = sub_genre.to_s
    key = "delivery_partner" unless CTAS.key?(key)
    CTAS[key]
  end

  def self.extract_sub_genre(html)
    return nil if html.nil? || html.empty?

    match = html.match(/<meta[^>]*name=["']jwork-sub-genre["'][^>]*content=["']([^"']*)["']/i) ||
            html.match(/<meta[^>]*content=["']([^"']*)["'][^>]*name=["']jwork-sub-genre["']/i)
    value = match&.[](1)
    value.nil? || value.empty? ? nil : value
  end
end
