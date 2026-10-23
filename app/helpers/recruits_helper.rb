module RecruitsHelper
  def recruit_metric_row(recruit, options = {})
    show_labels = options.fetch(:labels, false)
    content_tag(:div, class: "recruit-metrics") do
      safe_join([
        recruit_metric_item("view", recruit.views_count.to_i, "閲覧", show_labels),
        recruit_metric_item("save", recruit.saves_count.to_i, "保存", show_labels),
        recruit_metric_item("apply", recruit.applications_count.to_i, "応募", show_labels)
      ])
    end
  end

  def recruit_area_tags(area)
    parts = Recruit.area_parts(area)
    return if parts.empty?

    safe_join(parts.map { |part| content_tag(:span, part, class: "jobs-card__tag") })
  end

  def recruit_page_description(recruit)
    places = Recruit.area_parts(recruit.area)
    place_text = if places.one?
      "勤務地は#{places.first}です。"
    elsif places.many?
      "勤務地は複数あります。"
    else
      ""
    end
    "外国人材向けの求人です。#{recruit.title}。#{place_text}".squish.truncate(120)
  end

  def job_posting_json_ld(recruit)
    description = recruit.description.to_s.gsub(/\s+/, " ").strip
    description = recruit.title.to_s if description.blank?
    return if recruit.title.blank? || description.blank?

    posted_on = (recruit.created_at || recruit.updated_at)&.to_date
    payload = {
      "@context" => "https://schema.org/",
      "@type" => "JobPosting",
      "title" => recruit.title,
      "description" => description,
      "datePosted" => posted_on&.iso8601,
      "hiringOrganization" => {
        "@type" => "Organization",
        "name" => "株式会社J Work",
        "sameAs" => "https://j-work.jp/",
        "identifier" => {
          "@type" => "PropertyValue",
          "propertyID" => "有料職業紹介事業許可番号",
          "value" => employment_agency_license
        }
      },
      "identifier" => {
        "@type" => "PropertyValue",
        "name" => "株式会社J Work",
        "value" => recruit.id.to_s
      },
      "url" => recruit_url(recruit)
    }
    payload["industry"] = recruit.genre if recruit.genre.present?
    employment_type = job_posting_employment_type(recruit.contract_type)
    payload["employmentType"] = employment_type if employment_type.present?
    locations = job_posting_locations(recruit.area)
    payload["jobLocation"] = locations if locations.present?
    payload.delete("datePosted") if payload["datePosted"].blank?
    payload.to_json
  end

  def recruit_metric_item(kind, count, label, show_labels)
    content_tag(:span, class: "recruit-metric recruit-metric--#{kind}", title: label) do
      safe_join([
        recruit_metric_icon(kind),
        content_tag(:span, count, class: "recruit-metric__count", data: { metric: kind }),
        (show_labels ? content_tag(:span, label, class: "recruit-metric__label") : nil)
      ].compact)
    end
  end

  def job_posting_employment_type(contract_type)
    text = contract_type.to_s
    return if text.blank?
    return "PART_TIME" if text.match?(/アルバイト|パート|part[- ]?time/i)
    return "FULL_TIME" if text.match?(/正社員|full[- ]?time/i)
    return "CONTRACTOR" if text.match?(/契約|業務委託|contract/i)
    return "TEMPORARY" if text.match?(/派遣|temporary/i)
    return "INTERN" if text.match?(/インターン|intern/i)

    nil
  end

  def job_posting_locations(area)
    Recruit.area_parts(area).map do |label|
      region = label[/\A(北海道|東京都|大阪府|京都府|.+?県)/, 1]
      locality = region.present? ? label.delete_prefix(region).strip : label
      address = {
        "@type" => "PostalAddress",
        "addressCountry" => "JP"
      }
      address["addressRegion"] = region if region.present?
      address["addressLocality"] = locality if locality.present?
      address["addressLocality"] ||= label if region.blank?
      {
        "@type" => "Place",
        "address" => address
      }
    end
  end

  def recruit_metric_icon(kind)
    case kind.to_s
    when "view"
      <<~SVG.html_safe
        <svg class="recruit-metric__icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path fill="currentColor" d="M12 5c-5 0-9.27 3.11-11 7 1.73 3.89 6 7 11 7s9.27-3.11 11-7c-1.73-3.89-6-7-11-7zm0 12a5 5 0 1 1 0-10 5 5 0 0 1 0 10zm0-8a3 3 0 1 0 .001 6.001A3 3 0 0 0 12 9z"/></svg>
      SVG
    when "save"
      <<~SVG.html_safe
        <svg class="recruit-metric__icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path fill="currentColor" d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 6 4 4 6.5 4c1.74 0 3.41 1 4.22 2.44C11.09 5 12.76 4 14.5 4 17 4 19 6 19 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
      SVG
    else
      <<~SVG.html_safe
        <svg class="recruit-metric__icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path fill="currentColor" d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
      SVG
    end
  end
end
