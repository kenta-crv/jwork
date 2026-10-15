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
    language: [
      { title: "語学教室の人手不足を解消する採用方法｜求人・派遣・人材紹介・業務委託を比較", path: "/columns/language-school-hiring-methods-job-dispatch-agency" },
      { title: "語学教室の求人を出しても応募が来ない原因は？採用条件と募集方法の見直し方", path: "/columns/language-school-job-posting-no-applicants" },
      { title: "語学教室の人材確保は派遣・人材紹介・求人掲載のどれがよい？違いと選び方", path: "/columns/language-school-dispatch-agency-job-posting" },
      { title: "語学教室の外国人講師採用ガイド｜募集前に確認したい授業内容・日本語力・受け入れ体制", path: "/columns/language-school-foreign-teacher-hiring-guide" },
      { title: "語学教室のグループレッスン講師を採用するには？応募者に伝える仕事内容と勤務条件", path: "/columns/language-school-group-lesson-teacher-hiring" },
      { title: "語学講師の採用方法｜派遣・業務委託・直接雇用の違い", path: "/columns/language-teacher-hiring-dispatch-outsourcing-direct" },
      { title: "語学教室の授業を業務委託するには？依頼前に決めておきたい業務範囲と条件", path: "/columns/language-school-lesson-outsourcing-scope" },
      { title: "語学教室の夜間・土日講師を採用するには？勤務条件の伝え方と人員確保のポイント", path: "/columns/language-school-evening-weekend-teacher-hiring" },
      { title: "中国語・韓国語講師の採用で見直したい求人条件と募集方法", path: "/columns/language-school-chinese-korean-teacher-hiring" },
      { title: "子供向け語学教室の人手不足を解消する採用方法｜講師と受付の確保", path: "/columns/kids-language-school-teacher-hiring" },
      { title: "語学教室の正社員講師採用が難しいときに検討したい人材確保の方法", path: "/columns/language-school-fulltime-teacher-alternatives" },
      { title: "語学教室の採用コストを抑えるには？求人広告・派遣・人材紹介を比較", path: "/columns/language-school-hiring-cost-comparison" },
      { title: "語学教室の採用後の定着率を高めるには？受け入れ体制と授業環境の整え方", path: "/columns/language-school-teacher-retention-onboarding" }
    ],
    english: [
      { title: "英会話スクールの人手不足を解消する採用方法｜求人・派遣・人材紹介・業務委託を比較", path: "/columns/english-school-hiring-methods-job-dispatch-agency" },
      { title: "英会話スクールの求人を出しても応募が来ない原因は？採用条件と募集方法の見直し方", path: "/columns/english-school-job-posting-no-applicants" },
      { title: "英会話スクールの人材確保は派遣・人材紹介・求人掲載のどれがよい？違いと選び方", path: "/columns/english-school-dispatch-agency-job-posting" },
      { title: "英会話スクールの外国人講師採用ガイド｜募集前に確認したい授業内容・日本語力・受け入れ体制", path: "/columns/english-school-foreign-teacher-hiring-guide" },
      { title: "子供英会話の講師採用を成功させるには？応募者に伝える仕事内容と勤務条件", path: "/columns/kids-english-teacher-hiring-job-conditions" },
      { title: "英語講師の採用方法｜派遣・業務委託・直接雇用の違い", path: "/columns/english-teacher-hiring-dispatch-outsourcing-direct" },
      { title: "英会話の授業を業務委託するには？依頼前に決めておきたい業務範囲と条件", path: "/columns/english-lesson-outsourcing-scope" },
      { title: "英会話スクールの夜間・土日講師を採用するには？勤務条件の伝え方と人員確保のポイント", path: "/columns/english-school-evening-weekend-teacher-hiring" },
      { title: "ネイティブ英語講師の採用で見直したい求人条件と募集方法", path: "/columns/native-english-teacher-hiring-conditions" },
      { title: "企業向け英会話の人手不足を解消する採用方法｜講師の確保", path: "/columns/corporate-english-teacher-hiring" },
      { title: "英会話スクールの正社員講師採用が難しいときに検討したい人材確保の方法", path: "/columns/english-school-fulltime-teacher-alternatives" },
      { title: "英会話スクールの採用コストを抑えるには？求人広告・派遣・人材紹介を比較", path: "/columns/english-school-hiring-cost-comparison" },
      { title: "英会話スクールの採用後の定着率を高めるには？受け入れ体制と授業環境の整え方", path: "/columns/english-school-teacher-retention-onboarding" }
    ],
    restaurant: [
      { title: "飲食店の人手不足を解消する採用方法｜求人・人材紹介・斡旋を比較", path: "/columns/restaurant-hiring-methods-job-agency-placement" },
      { title: "飲食店の求人を出しても応募が来ない原因は？採用条件と募集方法の見直し方", path: "/columns/restaurant-job-posting-no-applicants" },
      { title: "飲食店の人材確保は人材紹介・求人掲載・斡旋のどれがよい？違いと選び方", path: "/columns/restaurant-staffing-agency-posting-placement" },
      { title: "飲食店の外国人材採用ガイド｜募集前に確認したい仕事内容・日本語力・受け入れ体制", path: "/columns/restaurant-foreign-talent-hiring-guide" },
      { title: "ホールスタッフを採用するには？応募者に伝える仕事内容と勤務条件", path: "/columns/restaurant-hall-staff-hiring-job-conditions" },
      { title: "キッチンスタッフの採用方法｜求人・人材紹介・直接雇用の違い", path: "/columns/restaurant-kitchen-staff-hiring-methods" },
      { title: "洗い場・仕込みを任せる前に決めておきたい業務範囲と条件", path: "/columns/restaurant-prep-dish-work-scope" },
      { title: "飲食店の夜間・週末スタッフを採用するには？勤務条件の伝え方と人員確保のポイント", path: "/columns/restaurant-evening-weekend-staff-hiring" },
      { title: "居酒屋・カフェの採用で見直したい求人条件と募集方法", path: "/columns/restaurant-izakaya-cafe-hiring-conditions" },
      { title: "ランチ営業の人手不足を解消する採用方法｜ホールとキッチンの確保", path: "/columns/restaurant-lunch-hall-kitchen-hiring" },
      { title: "飲食店の正社員採用が難しいときに検討したい人材確保の方法", path: "/columns/restaurant-fulltime-hiring-alternatives" },
      { title: "飲食店の採用コストを抑えるには？求人広告・人材紹介・斡旋を比較", path: "/columns/restaurant-hiring-cost-comparison" },
      { title: "飲食店の採用後の定着率を高めるには？受け入れ体制と現場の整え方", path: "/columns/restaurant-retention-onboarding" }
    ],
    warehouse: [
      { title: "物流倉庫の人手不足を解消する採用方法｜求人・人材紹介・斡旋を比較", path: "/columns/warehouse-hiring-methods-job-agency-placement" },
      { title: "物流倉庫の求人を出しても応募が来ない原因は？採用条件と募集方法の見直し方", path: "/columns/warehouse-job-posting-no-applicants" },
      { title: "物流倉庫の人材確保は人材紹介・求人掲載・斡旋のどれがよい？違いと選び方", path: "/columns/warehouse-staffing-agency-posting-placement" },
      { title: "物流倉庫の外国人材採用ガイド｜募集前に確認したい仕事内容・日本語力・受け入れ体制", path: "/columns/warehouse-foreign-talent-hiring-guide" },
      { title: "ピッキングスタッフを採用するには？応募者に伝える仕事内容と勤務条件", path: "/columns/warehouse-picking-staff-hiring" },
      { title: "梱包・仕分けスタッフの採用方法｜求人・人材紹介・直接雇用の違い", path: "/columns/warehouse-packing-sorting-hiring-methods" },
      { title: "入出庫を任せる前に決めておきたい業務範囲と条件", path: "/columns/warehouse-inbound-outbound-scope" },
      { title: "物流倉庫の早朝・深夜スタッフを採用するには？勤務条件の伝え方と人員確保のポイント", path: "/columns/warehouse-early-night-shift-hiring" },
      { title: "繁忙期の倉庫採用で見直したい求人条件と募集方法", path: "/columns/warehouse-peak-season-hiring-conditions" },
      { title: "仕分け拠点の人手不足を解消する採用方法｜ピッキングと梱包の確保", path: "/columns/warehouse-sorting-hub-picking-packing" },
      { title: "物流倉庫の正社員採用が難しいときに検討したい人材確保の方法", path: "/columns/warehouse-fulltime-hiring-alternatives" },
      { title: "物流倉庫の採用コストを抑えるには？求人広告・人材紹介・斡旋を比較", path: "/columns/warehouse-hiring-cost-comparison" },
      { title: "物流倉庫の採用後の定着率を高めるには？受け入れ体制と現場の整え方", path: "/columns/warehouse-retention-onboarding" }
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
    []
  end
end
