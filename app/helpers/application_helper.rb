module ApplicationHelper
  FEATURED_COLUMNS = {
    cargo: [
      { title: "荷主企業向け 軽貨物配送の委託・比較 完全ガイド", path: "/columns/shipper-light-cargo-outsourcing-comparison-guide" },
      { title: "Amazon配送の人材不足・採用改善 完全ガイド", path: "/columns/amazon-delivery-talent-shortage-complete-guide" },
      { title: "Amazon配送会社向け人材請負サービス完全ガイド", path: "/columns/amazon-guide-delivery-cargo" },
      { title: "Amazon配送ドライバー採用の成功パターン完全解説", path: "/columns/amazon-driver-complete-guide-delivery-hiring" },
      { title: "軽貨物サービスのすべて｜緊急配送・スポット便・定期便の違いを網羅", path: "/columns/light-cargo-delivery" }
    ],
    logistics: [
      { title: "自社配送 vs 軽貨物委託｜企業の物流担当者が知っておくべきメリット・デメリット徹底比較", path: "/columns/in-house-delivery-vs-light-cargo-outsourcing" },
      { title: "物流DXの第一歩は軽貨物から：企業が取り入れるべき理由と成功事例", path: "/columns/first-step-logistics-dx" },
      { title: "「必要な時だけ頼む」スポット便活用による物流固定費の変動費化", path: "/columns/spot-delivery-utilization" },
      { title: "【実例公開】軽貨物配送の導入で物流効率が向上した成功事例5選（BtoB・BtoC別）", path: "/columns/light-cargo-delivery-case-studies" },
      { title: "軽貨物委託の料金相場ガイド｜距離制・時間制・スポットの選び方", path: "/columns/light-cargo-commission-price-guide" }
    ],
    human: [
      { title: "在留資格別に外国人が働ける仕事｜企業が採用前に確認すること", path: "/columns/work-allowed-by-residence-status-for-employers" },
      { title: "特定技能で従事できる仕事｜分野・業務区分の範囲", path: "/columns/specified-skilled-worker-work-jobs-field-scope" },
      { title: "特定技能の採用基準｜試験・日本語・分野該当の確認", path: "/columns/tokutei-gino-hiring-criteria" },
      { title: "外国人配送ドライバー活用完全ガイド【2026年版】", path: "/columns/foreign-driver-guide-2026" },
      { title: "外国人ドライバー採用のメリット・注意点まとめ", path: "/columns/hiring-foreign-drivers-amazon-delivery" }
    ],
    event: [
      { title: "特定技能と育成就労の現場の違い｜配置・教育・記録の具体例", path: "/columns/tokutei-gino-ikusei-shuro-workplace-examples" },
      { title: "特定技能の定着支援｜支援義務と現場で企業がやる実務", path: "/columns/tokutei-gino-retention-support-duty" },
      { title: "育成就労外国人の受け入れ｜責任者・指導員・生活相談員の役割", path: "/columns/ikusei-shuro-staff-roles-acceptance" },
      { title: "在留資格別に外国人が働ける仕事｜企業が採用前に確認すること", path: "/columns/work-allowed-by-residence-status-for-employers" },
      { title: "特定技能で従事できる仕事｜分野・業務区分の範囲", path: "/columns/specified-skilled-worker-work-jobs-field-scope" }
    ],
    cleaning: [
      { title: "在留資格別に外国人が働ける仕事｜企業が採用前に確認すること", path: "/columns/work-allowed-by-residence-status-for-employers" },
      { title: "特定技能で従事できる仕事｜分野・業務区分の範囲", path: "/columns/specified-skilled-worker-work-jobs-field-scope" },
      { title: "特定技能の採用基準｜試験・日本語・分野該当の確認", path: "/columns/tokutei-gino-hiring-criteria" },
      { title: "育成就労外国人の受け入れ｜責任者・指導員・生活相談員の役割", path: "/columns/ikusei-shuro-staff-roles-acceptance" },
      { title: "留学生をアルバイトで雇える条件｜許可の有無と週28時間まで", path: "/columns/student-status-part-time-work-permission-28hours" }
    ],
    top: [
      { title: "在留資格別に外国人が働ける仕事｜企業が採用前に確認すること", path: "/columns/work-allowed-by-residence-status-for-employers" },
      { title: "特定技能で従事できる仕事｜分野・業務区分の範囲", path: "/columns/specified-skilled-worker-work-jobs-field-scope" },
      { title: "荷主企業向け 軽貨物配送の委託・比較 完全ガイド", path: "/columns/shipper-light-cargo-outsourcing-comparison-guide" },
      { title: "Amazon配送の人材不足・採用改善 完全ガイド", path: "/columns/amazon-delivery-talent-shortage-complete-guide" },
      { title: "自社配送 vs 軽貨物委託｜企業の物流担当者が知っておくべきメリット・デメリット徹底比較", path: "/columns/in-house-delivery-vs-light-cargo-outsourcing" }
    ]
  }.freeze

  def default_meta_tags
    {
      site: "外国人専門の人材提供ならJ Work｜株式会社J Work",
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
    "/columns"
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
      "description" => "外国人専門の人材提供ならJ Work。軽貨物・配送・清掃など現場人材を支援します。",
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
