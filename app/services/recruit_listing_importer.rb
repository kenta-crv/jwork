# frozen_string_literal: true

require "net/http"
require "uri"
require "json"
require "cgi"
require "ipaddr"
require "resolv"

# 公開求人URL（求人ボックス等）から JobPosting 情報を読み取り、
# Recruit フォーム用の属性ハッシュに変換する。
# Indeed はボット対策のため非対応（事前拒否）。
class RecruitListingImporter
  Result = Struct.new(:attributes, :error, keyword_init: true)

  USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"
  TIMEOUT = 20
  MAX_REDIRECTS = 5

  SECTION_PATTERNS = {
    working_hours: /勤務時間(?:・曜日)?/,
    working_days: /勤務日数|勤務曜日/,
    area: /勤務地/,
    payment: /支払(?:い)?日|支給日/,
    require: /応募資格|求める人材|必須資格|応募条件/,
    contract_type: /雇用形態/,
    unit_price: /給与(?:・報酬)?|報酬/,
    car_details: /車両/,
    recommend: /アピールポイント|待遇・福利厚生|待遇/,
    remarks: /その他|備考|注意事項/
  }.freeze

  EMPLOYMENT_TYPE_JA = {
    "FULL_TIME" => "正社員",
    "PART_TIME" => "アルバイト・パート",
    "CONTRACTOR" => "業務委託",
    "TEMPORARY" => "契約・派遣",
    "INTERN" => "インターン",
    "OTHER" => "その他"
  }.freeze

  def self.call(url)
    new(url).call
  end

  def initialize(url)
    @url = url.to_s.strip
  end

  def call
    return Result.new(attributes: {}, error: "URLを入力してください") if @url.blank?

    uri = parse_public_uri!(@url)
    reject_unsupported_source!(uri)
    html = fetch_html(uri)
    posting = extract_job_posting(html)
    attrs = posting ? attributes_from_job_posting(posting, html) : attributes_from_fallback(html)

    if attrs.values.all?(&:blank?)
      return Result.new(attributes: {}, error: "求人情報を読み取れませんでした。URLをご確認ください")
    end

    Result.new(attributes: attrs, error: nil)
  rescue UnsupportedSourceError => e
    Rails.logger.warn("[RecruitListingImporter] #{e.class}: #{e.message}")
    Result.new(attributes: {}, error: e.message)
  rescue => e
    Rails.logger.warn("[RecruitListingImporter] #{e.class}: #{e.message}")
    Result.new(attributes: {}, error: "読み込みに失敗しました（#{e.message}）")
  end

  private

  class UnsupportedSourceError < StandardError; end

  def parse_public_uri!(raw)
    uri = URI.parse(raw)
    raise "http/https のURLのみ対応しています" unless %w[http https].include?(uri.scheme)
    raise "URLが不正です" if uri.host.blank?
    raise "内部向けURLは指定できません" if private_host?(uri.host)

    uri
  end

  def reject_unsupported_source!(uri)
    return unless indeed_host?(uri.host)

    raise UnsupportedSourceError,
          "IndeedのURLは読み込めません（ボット対策のため取得不可）。" \
          "求人ボックスの求人詳細URLを使うか、内容を手入力してください。"
  end

  def indeed_host?(host)
    host.to_s.match?(/(^|\.)indeed\./i)
  end

  def private_host?(host)
    return true if %w[localhost 127.0.0.1 0.0.0.0 ::1].include?(host)

    ip = IPAddr.new(Resolv.getaddress(host))
    ip.loopback? || ip.private? || ip.link_local?
  rescue IPAddr::InvalidAddressError, Resolv::ResolvError, SocketError
    false
  end

  def fetch_html(uri)
    cookie = ""
    current = uri

    follow_request(current, cookie)
  end

  def follow_request(uri, cookie)
    current = uri
    redirects = 0

    loop do
      raise "リダイレクトが多すぎます" if redirects > MAX_REDIRECTS

      res, cookie = perform_get(current, cookie)

      case res
      when Net::HTTPRedirection
        location = res["Location"]
        raise "リダイレクト先がありません" if location.blank?

        current = URI.join("#{current.scheme}://#{current.host}", location)
        parse_public_uri!(current.to_s)
        reject_unsupported_source!(current)
        redirects += 1
      when Net::HTTPSuccess
        return decode_body(res.body.to_s)
      else
        raise "掲載ページの取得に失敗しました (#{res.code})"
      end
    end
  end

  def decode_body(body)
    body.force_encoding("UTF-8")
    body = body.encode("UTF-8", invalid: :replace, undef: :replace) unless body.valid_encoding?
    body
  end

  def perform_get(uri, cookie)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"
    http.open_timeout = TIMEOUT
    http.read_timeout = TIMEOUT

    path = uri.request_uri
    path = "/" if path.blank?
    req = Net::HTTP::Get.new(path)
    req["User-Agent"] = USER_AGENT
    req["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8"
    req["Accept-Language"] = "ja-JP,ja;q=0.9,en-US;q=0.8,en;q=0.7"
    req["Accept-Encoding"] = "identity"
    req["Upgrade-Insecure-Requests"] = "1"
    req["Sec-Fetch-Dest"] = "document"
    req["Sec-Fetch-Mode"] = "navigate"
    req["Sec-Fetch-Site"] = "none"
    req["Sec-Fetch-User"] = "?1"
    req["Cookie"] = cookie if cookie.present?
    req["Referer"] = "#{uri.scheme}://#{uri.host}/"

    res = http.request(req)
    if res.get_fields("Set-Cookie")
      parts = res.get_fields("Set-Cookie").map { |c| c.split(";").first }
      cookie = [cookie, *parts].reject(&:blank?).join("; ")
    end
    [res, cookie]
  end

  def extract_job_posting(html)
    doc = Nokogiri::HTML(html)
    doc.css('script[type="application/ld+json"]').each do |node|
      data = parse_json_safe(node.text)
      posting = find_job_posting(data)
      return posting if posting
    end
    nil
  end

  def parse_json_safe(text)
    JSON.parse(text)
  rescue JSON::ParserError
    nil
  end

  def find_job_posting(data)
    case data
    when Array
      data.each do |item|
        found = find_job_posting(item)
        return found if found
      end
    when Hash
      type = Array(data["@type"]).map(&:to_s)
      return data if type.include?("JobPosting")

      if data["@graph"]
        found = find_job_posting(data["@graph"])
        return found if found
      end
    end
    nil
  end

  def attributes_from_job_posting(posting, html)
    description_html = posting["description"].to_s
    description_text = html_to_text(description_html)
    sections = extract_sections(description_text)

    title = preferred_title(clean_text(posting["title"]), meta_content(html, "og:title"))
    salary_text = format_salary(posting["baseSalary"])
    location = format_location(posting["jobLocation"])
    employment = format_employment_type(posting["employmentType"])
    requirements = [
      posting["experienceRequirements"],
      posting["qualifications"],
      posting["skills"]
    ].flatten.compact.map { |v| html_to_text(v.to_s) }.reject(&:blank?).join("\n")

    genre = infer_genre("#{title}\n#{description_text}")

    {
      title: title,
      description: description_text.presence,
      recommend: compact_section(sections[:recommend]),
      genre: genre,
      unit_price: salary_text.presence || compact_section(sections[:unit_price]),
      reward: salary_text.presence || compact_section(sections[:unit_price]),
      working_hours: clean_text(posting["workHours"]).presence || compact_section(sections[:working_hours]),
      working_days: compact_section(sections[:working_days]),
      area: location.presence || compact_section(sections[:area]),
      payment: compact_section(sections[:payment]),
      require: requirements.presence || compact_section(sections[:require]),
      contract_type: employment.presence || compact_section(sections[:contract_type]),
      car_details: compact_section(sections[:car_details]),
      remarks: compact_section(sections[:remarks]).presence || organization_name(posting)
    }.transform_values { |v| blank_to_nil(v) }
  end

  def preferred_title(posting_title, og_title)
    cleaned_og = clean_job_title(og_title)
    return posting_title if cleaned_og.blank?
    return cleaned_og if posting_title.blank?
    return cleaned_og if cleaned_og.length > posting_title.length + 5

    posting_title
  end

  def compact_section(value)
    text = value.to_s.strip
    return nil if text.blank?

    # 次項目の見出しが混ざったらそこで切る
    text = text.split(/\n(?=【|[■✅]|勤務|給与|待遇|雇用|応募|その他|アクセス)/, 2).first.to_s
    text = text.lines.first(8).join.strip
    text.presence
  end

  def attributes_from_fallback(html)
    title = clean_job_title(meta_content(html, "og:title"))
    description = html_to_text(meta_content(html, "og:description").to_s)
    text = html_to_text(html)
    sections = extract_sections(text)

    {
      title: title,
      description: description.presence || sections[:description],
      recommend: sections[:recommend],
      genre: infer_genre("#{title}\n#{description}\n#{text}"),
      unit_price: sections[:unit_price],
      reward: sections[:unit_price],
      working_hours: sections[:working_hours],
      working_days: sections[:working_days],
      area: sections[:area],
      payment: sections[:payment],
      require: sections[:require],
      contract_type: sections[:contract_type],
      car_details: sections[:car_details],
      remarks: sections[:remarks]
    }.transform_values { |v| blank_to_nil(v) }
  end

  def extract_sections(text)
    return {} if text.blank?

    normalized = text.gsub(/\r\n?/, "\n")
    # 同一キーでも本文中の出現位置をすべて拾い、直前〜直後の見出しで区切る
    label_regex = Regexp.union(SECTION_PATTERNS.values)
    matches = []
    normalized.scan(/(?:^|\n)\s*(#{label_regex.source})\s*[:：]?\s*/) do
      label = Regexp.last_match(1)
      key = SECTION_PATTERNS.find { |_k, pattern| label.match?(pattern) }&.first
      next unless key

      matches << {
        key: key,
        content_start: Regexp.last_match.end(0),
        label_start: Regexp.last_match.begin(0)
      }
    end

    result = {}
    matches.each_with_index do |current, idx|
      next if result[current[:key]].present?

      content_end = idx + 1 < matches.length ? matches[idx + 1][:label_start] : normalized.length
      value = normalized[current[:content_start]...content_end].to_s.strip
      value = value.gsub(/\n{3,}/, "\n\n").strip
      result[current[:key]] = value if value.present?
    end
    result
  end

  def format_salary(base_salary)
    return nil if base_salary.blank?

    currency = base_salary.is_a?(Hash) ? base_salary["currency"] : nil
    value_node = base_salary.is_a?(Hash) ? base_salary["value"] : base_salary
    return clean_text(value_node.to_s) unless value_node.is_a?(Hash)

    amount = value_node["value"] || value_node["minValue"]
    max_amount = value_node["maxValue"]
    unit = value_node["unitText"].to_s.upcase
    prefix =
      case unit
      when "HOUR" then "時給"
      when "DAY" then "日給"
      when "WEEK" then "週給"
      when "MONTH" then "月給"
      when "YEAR" then "年収"
      else "給与"
      end

    amount_text = [amount, max_amount].compact.map { |n| format_number(n) }.uniq.join("〜")
    return nil if amount_text.blank?

    unit_suffix = currency.to_s.upcase == "JPY" || currency.blank? ? "円" : " #{currency}"
    "#{prefix}#{amount_text}#{unit_suffix}"
  end

  def format_number(value)
    num = value.to_s.gsub(/[^\d.]/, "")
    return value.to_s if num.blank?

    if num.include?(".")
      num
    else
      num.to_i.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    end
  end

  def format_location(job_location)
    place = job_location.is_a?(Array) ? job_location.first : job_location
    return clean_text(place.to_s) unless place.is_a?(Hash)

    address = place["address"] || place
    if address.is_a?(Hash)
      parts = [
        address["addressRegion"],
        address["addressLocality"],
        address["streetAddress"]
      ].map { |v| clean_text(v) }.compact

      # 「東京都 東京足立区 足立区」のような重複を抑える
      uniq_parts = []
      parts.each do |part|
        next if uniq_parts.any? { |p| p.include?(part) || part.include?(p) }

        uniq_parts << part
      end
      uniq_parts.join(" ")
    else
      clean_text(address.to_s)
    end
  end

  def format_employment_type(value)
    types = Array(value).map(&:to_s)
    return nil if types.blank?

    types.map { |t| EMPLOYMENT_TYPE_JA[t.upcase] || t }.uniq.join(" / ")
  end

  def organization_name(posting)
    org = posting["hiringOrganization"]
    return nil unless org.is_a?(Hash)

    name = clean_text(org["name"])
    name.present? ? "掲載元: #{name}" : nil
  end

  def infer_genre(text)
    t = text.to_s
    return "cleaning" if t.match?(/清掃|クリーニング|cleaning/i)
    return "driver" if t.match?(/配達|配送|ドライバー|軽貨物|運転|driver|delivery/i)

    nil
  end

  def meta_content(html, property)
    doc = Nokogiri::HTML(html)
    node = doc.at_css(%(meta[property="#{property}"])) || doc.at_css(%(meta[name="#{property}"]))
    node&.[]("content")
  end

  def clean_job_title(title)
    text = clean_text(title)
    return nil if text.blank?

    text
      .sub(/\s*[-|｜].*(Indeed|求人ボックス|インディード).*$/i, "")
      .sub(/\s*のバイト求人詳細情報.*$/i, "")
      .strip
      .presence
  end

  def html_to_text(html)
    return "" if html.blank?

    doc = Nokogiri::HTML.fragment(html.to_s)
    doc.css("br").each { |br| br.replace("\n") }
    doc.css("p,div,li,tr").each { |el| el.after("\n") }
    text = CGI.unescapeHTML(doc.text.to_s)
    text.gsub(/\u00a0/, " ").gsub(/[ \t]+\n/, "\n").gsub(/\n{3,}/, "\n\n").strip
  end

  def clean_text(value)
    text = value.to_s.gsub(/\s+/, " ").strip
    text.presence
  end

  def blank_to_nil(value)
    value.respond_to?(:strip) ? value.strip.presence : value
  end
end
