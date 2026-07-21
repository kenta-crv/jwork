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
      site: "外国人専門の人材提供ならJ Work｜株式会社セールスプロ",
      title: "合同会社ファクトル",
      reverse: true,
      separator: '|',
      description: "",
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
end
