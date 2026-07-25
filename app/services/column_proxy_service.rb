# frozen_string_literal: true

require "net/http"
require "uri"

# drafity の /cargo/columns を取得し、j-work.jp 向けに書き換え・導線注入する
class ColumnProxyService
  DRAFITY_ORIGIN = "https://drafity.pro"
  DRAFITY_COLUMNS_BASE = "#{DRAFITY_ORIGIN}/cargo/columns"

  def initialize(request_path:, query_string: nil)
    @request_path = request_path.to_s
    @query_string = query_string.presence
  end

  def call
    response = fetch_upstream
    body = response.body.to_s.dup
    body.force_encoding(Encoding::UTF_8)
    body = body.encode(Encoding::UTF_8, invalid: :replace, undef: :replace) unless body.valid_encoding?

    body = rewrite_urls(body)
    body = inject_line_cta(body) if article_show?

    {
      status: response.code.to_i,
      content_type: response["Content-Type"].presence || "text/html; charset=utf-8",
      body: body
    }
  end

  private

  def article_show?
    # /columns/:code （一覧や末尾スラッシュのみは除外）
    @request_path.match?(%r{\A/columns/[^/]+/?\z})
  end

  def upstream_uri
    suffix = @request_path.sub(%r{\A/columns}, "")
    suffix = "" if suffix == "/"
    uri = URI("#{DRAFITY_COLUMNS_BASE}#{suffix}")
    uri.query = @query_string if @query_string.present?
    uri
  end

  def fetch_upstream
    uri = upstream_uri
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")
    http.open_timeout = 5
    http.read_timeout = 20

    req = Net::HTTP::Get.new(uri)
    req["Host"] = "drafity.pro"
    req["X-Forwarded-Host"] = "j-work.jp"
    req["X-Forwarded-Proto"] = "https"
    req["X-Brand-Lp-Path"] = "/pages/cargo"
    req["Accept-Encoding"] = "identity"
    req["User-Agent"] = "JWorkColumnProxy/1.0"

    http.request(req)
  end

  def rewrite_urls(html)
    html
      .gsub("https://drafity.pro", "https://j-work.jp")
      .gsub("http://drafity.pro", "https://j-work.jp")
      .gsub("/assets_ok/", "/remote-assets/")
      .gsub("/assets/", "/remote-assets/")
      .gsub("/cargo/columns", "/columns")
  end

  def inject_line_cta(html)
    return html if html.include?("jwork-line-cta")

    sub_genre = ColumnLineCta.extract_sub_genre(html)
    cta = ColumnLineCta.for_sub_genre(sub_genre)
    snippet = ColumnLineCtaHtml.render(cta)

    if html.include?('class="column-footer"') || html.include?("class='column-footer'")
      html.sub(%r{<div[^>]*class=["'][^"']*column-footer}, "#{snippet}\\0")
    elsif html.include?("</body>")
      html.sub("</body>", "#{snippet}</body>")
    else
      html + snippet
    end
  end
end
