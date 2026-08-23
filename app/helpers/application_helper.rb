module ApplicationHelper
  FEATURED_COLUMNS = {
    cargo: [
      { title: "Amazon配送の効率化に寄与する外国人ドライバーの事例", path: "/columns/amazon-delivery-foreign-drivers" },
      { title: "外国人ドライバーが支えるAmazon配送の現場", path: "/columns/foreign-driver-support-amazon-delivery" },
      { title: "軽貨物業界の2026年におけるサプライチェーンの変革", path: "/columns/transformation-supply-chain-light-cargo-industry-2026" },
      { title: "2026年の軽貨物業界における物流の効率化事例", path: "/columns/2026-logistics-efficiency-light-cargo-industry" },
      { title: "軽貨物業界の2026年に向けた新規参入者へのアドバイス", path: "/columns/light-cargo-industry-advice-2026" }
    ],
    logistics: [
      { title: "外国人ドライバーと日本の物流業界の共生", path: "/columns/foreign-driver-logistics-japan" },
      { title: "2026年の軽貨物業界における物流の効率化事例", path: "/columns/2026-logistics-efficiency-light-cargo-industry" },
      { title: "軽貨物業界における業務効率化のための最新技術", path: "/columns/latest-technologies-in-light-cargo-industry" },
      { title: "軽貨物業界の2026年最新動向：データドリブンな運用の重要性", path: "/columns/latest-trends-in-light-cargo-industry-2026" },
      { title: "軽貨物業界における顧客ニーズの変化と対応策", path: "/columns/customer-needs-in-light-cargo-industry" }
    ],
    human: [
      { title: "Amazon配送における外国人ドライバーの成功事例", path: "/columns/success-stories-of-foreign-drivers-in-amazon-delivery" },
      { title: "国際的な人材活用がAmazon配送を変える", path: "/columns/international-talent-utilization-amazon-delivery" },
      { title: "Amazon配送戦略における外国人労働者の重要性", path: "/columns/importance-of-foreign-workers-in-amazon-delivery-strategy" },
      { title: "Amazon配送における多様な人材活用の現状", path: "/columns/amazon-delivery-diverse-human-resource-utilization" },
      { title: "2026年の軽貨物業界における人材育成とその課題", path: "/columns/2026-light-cargo-industry-human-resource-development-challenges" }
    ],
    event: [
      { title: "軽貨物業界の2026年に向けたマーケティング戦略の再考", path: "/columns/marketing-strategies-light-cargo-industry-2026" },
      { title: "2026年の軽貨物業界における顧客体験の向上方法", path: "/columns/customer-experience-improvement-light-cargo-industry-2026" },
      { title: "軽貨物業界の2026年におけるリスクマネジメントの重要性", path: "/columns/risk-management-light-cargo-industry-2026" },
      { title: "2026年における軽貨物業界の競争環境と生存戦略", path: "/columns/competition-environment-light-cargo-industry-2026" },
      { title: "軽貨物業界の2026年に向けた持続可能な運営戦略", path: "/columns/sustainable-strategies-for-light-cargo-industry-2026" }
    ],
    cleaning: [
      { title: "清掃業者の選び方: 品質を重視した判断基準", path: "https://okey.work/columns/how-to-choose-cleaning-service-7a0d021f-5b76-4eeb-a114-a88aa45b69e1" },
      { title: "失敗しない清掃業者の選び方: ケーススタディ", path: "https://okey.work/columns/cleaning-service-selection-bf7841c6-5c44-4746-bd8e-1e617507c62b" },
      { title: "日常清掃の業者選び：失敗しないためのガイド", path: "https://okey.work/columns/daily-cleaning-service-guide" },
      { title: "清掃業者選びにおける費用の透明性を確保する方法", path: "https://okey.work/columns/transparency-in-cleaning-service-costs" },
      { title: "日常清掃業者の選び方：信頼性と専門知識の重要性", path: "https://okey.work/columns/daily-cleaning-service-selection-b810974f-67c9-4117-aff7-4194bfee8785" }
    ],
    top: [
      { title: "Amazon配送の効率化に寄与する外国人ドライバーの事例", path: "/columns/amazon-delivery-foreign-drivers" },
      { title: "外国人ドライバーが支えるAmazon配送の現場", path: "/columns/foreign-driver-support-amazon-delivery" },
      { title: "外国人ドライバーと日本の物流業界の共生", path: "/columns/foreign-driver-logistics-japan" },
      { title: "軽貨物業界の2026年におけるサプライチェーンの変革", path: "/columns/transformation-supply-chain-light-cargo-industry-2026" },
      { title: "国際的な人材活用がAmazon配送を変える", path: "/columns/international-talent-utilization-amazon-delivery" }
    ]
  }.freeze

  def default_meta_tags
    {
      site: "外国人専門の人材提供ならJ Work｜株式会社J Work",
      title: "外国人材の採用と仕事・暮らしの情報",
      reverse: true,
      separator: '|',
      description: "登録3,000人・毎月約500人増。企業の外国人採用と、在留外国人の仕事・暮らしの情報を提供します。",
      canonical: request.original_url,
      charset: "UTF-8",
      icon: [
        { href: image_url('favicon.ico') },
        { href: image_url('favicon.ico'),  rel: 'apple-touch-icon' },
      ]
    }
  end

  def step_class(step_number)
    return 'is-active' if step_number == @current_step
    return 'is-done'   if step_number < @current_step
    ''
  end

  def featured_columns_for(page_key)
    FEATURED_COLUMNS[page_key.to_sym] || FEATURED_COLUMNS[:top]
  end

  def featured_columns_hub_for(page_key)
    page_key.to_sym == :cleaning ? "https://okey.work/columns" : "/columns"
  end

  def breadcrumb_list_json_ld
    return if breadcrumbs.blank?

    items = breadcrumbs.each_with_index.map do |crumb, i|
      name = crumb.name
      name = instance_exec(&name) if name.respond_to?(:call)
      path = crumb.path
      path = instance_exec(&path) if path.respond_to?(:call)

      item = {
        "@type" => "ListItem",
        "position" => i + 1,
        "name" => name
      }
      item["item"] = path.present? ? "#{request.base_url}#{path}" : request.original_url
      item
    end

    {
      "@context" => "https://schema.org",
      "@type" => "BreadcrumbList",
      "itemListElement" => items
    }.to_json
  end

  def organization_json_ld
    {
      "@context" => "https://schema.org",
      "@type" => "Organization",
      "name" => "J Work",
      "legalName" => "株式会社J Work",
      "url" => "https://j-work.jp/",
      "logo" => "https://j-work.jp#{image_path('favicon.ico')}",
      "description" => "外国人専門の人材プラットフォーム。登録3,000人規模の外国人材と、仕事・暮らしの情報を提供します。",
      "address" => {
        "@type" => "PostalAddress",
        "streetAddress" => "浜松町２丁目２番１５号２Ｆ",
        "addressLocality" => "港区",
        "addressRegion" => "東京都",
        "addressCountry" => "JP"
      }
    }.to_json
  end

  def website_json_ld
    {
      "@context" => "https://schema.org",
      "@type" => "WebSite",
      "name" => "J Work",
      "url" => "https://j-work.jp/",
      "inLanguage" => "ja",
      "publisher" => {
        "@type" => "Organization",
        "name" => "株式会社J Work"
      }
    }.to_json
  end

  def faq_page_json_ld(items)
    entities = Array(items).filter_map do |item|
      q = (item.is_a?(Array) ? item[0] : (item[:q] || item["q"])).to_s.strip
      a = (item.is_a?(Array) ? item[1] : (item[:a] || item["a"])).to_s.strip
      next if q.blank? || a.blank?

      {
        "@type" => "Question",
        "name" => q,
        "acceptedAnswer" => {
          "@type" => "Answer",
          "text" => a
        }
      }
    end
    return if entities.blank?

    {
      "@context" => "https://schema.org",
      "@type" => "FAQPage",
      "mainEntity" => entities
    }.to_json
  end

  def lp_faqs_for_current_page
    case action_name
    when "cargo"
      [
        { q: "どの地域まで対応可能ですか？", a: "名古屋・大阪・関東・福岡を中心に対応しています。条件によりその他のエリアもご相談いただけます。" },
        { q: "スポット対応は可能ですか？", a: "はい、案件内容に応じて一時的なご依頼にも対応いたします。" },
        { q: "夜間や早朝の配送にも対応できますか？", a: "はい、事前にご相談いただければ対応可能です。配送時間や曜日など柔軟に調整いたします。" },
        { q: "定期的な配送契約は可能ですか？", a: "可能です。週単位・月単位など、ご希望のスケジュールに合わせた契約形態で対応いたします。" },
        { q: "どんな荷物を運べますか？", a: "軽貨物車両で運べる範囲（小口荷物・書類・商品・資材など）に対応しています。内容によっては確認が必要な場合があります。" },
        { q: "特に人材な豊富なエリアはありますか？", a: "愛知県・埼玉県・神奈川県・千葉県・大阪府は特に人材が豊富におります。" }
      ]
    when "cleaning"
      [
        { q: "どの地域まで対応可能ですか？", a: "名古屋・大阪・関東・福岡を中心に対応しています。条件によりその他のエリアもご相談いただけます。" },
        { q: "スポット対応は可能ですか？", a: "はい、案件内容に応じて一時的なご依頼にも対応いたします。" },
        { q: "夜間や早朝の清掃にも対応できますか？", a: "はい、事前にご相談いただければ対応可能です。清掃時間や曜日など柔軟に調整いたします。" },
        { q: "定期的な清掃契約は可能ですか？", a: "可能です。年単位・月単位など、ご希望のスケジュールに合わせた契約形態で対応いたします。" },
        { q: "どんな清掃業務経験者がいますか？", a: "当社ではホテル清掃・公共清掃・屋内施設清掃と幅広い経験スタッフが在籍しております。" },
        { q: "特に人材な豊富なエリアはありますか？", a: "愛知県・埼玉県・神奈川県・千葉県・大阪府は特に人材が豊富におります。" }
      ]
    when "human"
      [
        { q: "対応エリアはどこまでですか？", a: "全国対応可能です。地域や業種により条件が異なりますのでご相談ください。" },
        { q: "複数事業をまとめて依頼できますか？", a: "はい、複数業種を一括でご依頼いただけます。" }
      ]
    when "event"
      [
        { q: "対応可能なエリアはどこですか？", a: "全国対応可能です。エリアにより条件が異なりますのでご相談ください。" },
        { q: "単日や短期間のイベントにも対応できますか？", a: "はい、単日・短期イベントにも柔軟に対応可能です。" },
        { q: "何名から依頼できますか？", a: "1名から大人数まで、案件内容に応じて手配可能です。" },
        { q: "どんな業務経験者がいますか？", a: "受付・誘導・設営補助など、幅広いイベント経験スタッフが在籍しています。" }
      ]
    when "logistics"
      [
        { q: "対応可能なエリアはどこですか？", a: "全国対応可能です。拠点により条件が異なりますのでご相談ください。" },
        { q: "単日や短期の作業にも対応できますか？", a: "はい、短期・スポット作業にも柔軟に対応可能です。" },
        { q: "何名から依頼できますか？", a: "1名から大量人員まで、案件内容に応じて手配可能です。" },
        { q: "どんな業務経験者がいますか？", a: "ピッキング・梱包・入出庫・検品経験者など、幅広い物流作業スタッフが在籍しています。" }
      ]
    else
      []
    end
  end
end
