# frozen_string_literal: true

# /columns を jwork が受け、drafity の記事HTMLを取得して導線を注入する
class ColumnsController < ApplicationController
  protect_from_forgery except: [:index, :show]

  def index
    proxy!
  end

  def show
    proxy!
  end

  private

  def proxy!
    result = ColumnProxyService.new(
      request_path: request.path,
      query_string: request.query_string.presence
    ).call

    response.headers["Cache-Control"] = "public, max-age=60"
    render html: result[:body].html_safe, layout: false, content_type: result[:content_type], status: result[:status]
  rescue StandardError => e
    Rails.logger.error("[ColumnsController] proxy failed: #{e.class}: #{e.message}")
    render plain: "Column temporarily unavailable", status: :bad_gateway
  end
end
