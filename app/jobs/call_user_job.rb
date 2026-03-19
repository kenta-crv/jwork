class CallUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return if user.nil? || user.tel.blank?

    # 1. 電話番号のクリーニング
    raw_tel = user.tel.sub(/^p:/, '').gsub(/[^\d+]/, '')

    formatted_to = nil
    if raw_tel.start_with?('+81')
      formatted_to = raw_tel
    elsif raw_tel.start_with?('0')
      formatted_to = "+81#{raw_tel[1..-1]}"
    end

    if formatted_to.nil?
      Rails.logger.warn "User ID: #{user.id} の番号 (#{user.tel}) は日本国内の番号ではないためスキップします。"
      return
    end

    # 2. 発信処理
    begin
      client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
      
      # ★修正ポイント：URLを文字列で直接書くのをやめ、Railsのヘルパーを使います。
      # 理由：ドメインやルーティングの不整合を物理的に防ぐためです。
      ivr_url = Rails.application.routes.url_helpers.show_ivr_user_url(user, host: 'j-work.jp')

      client.calls.create(
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: formatted_to,
        url: ivr_url
      )
      Rails.logger.info "User ID: #{user.id} へのIVR発信に成功しました。宛先: #{formatted_to} URL: #{ivr_url}"
    rescue => e
      # いまログに出ているエラーはここから出力されています。
      Rails.logger.error "IVR発信エラー (User ID: #{user_id}): #{e.message}"
    end
  end
end