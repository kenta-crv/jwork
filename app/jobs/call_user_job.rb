class CallUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return if user.nil? || user.tel.blank?

    # 1. 電話番号のクリーニング
    # 数字と + 以外をすべて除去
    raw_tel = user.tel.to_s.strip.sub(/^p:/, '').gsub(/[^\d+]/, '')

    formatted_to = nil
    
    # 判定ロジック：桁数指定を {9,11} に広げ、0から始まる11桁（携帯）を確実に拾う
    if raw_tel.match?(/^\+81\d{9,11}$/)
      formatted_to = raw_tel
    elsif raw_tel.match?(/^0\d{9,11}$/)
      # 先頭の 0 を除去して +81 を付与
      formatted_to = "+81#{raw_tel[1..-1]}"
    else
      Rails.logger.warn "User ID: #{user.id} の番号 (#{user.tel.inspect}) は形式外のためスキップ。raw_tel=#{raw_tel.inspect}"
      return
    end

    # 2. 発信処理
    begin
      # 実際に送る直前の値をログに強制出力（デバッグ用）
      Rails.logger.info "--- IVR CALL START: user_id=#{user.id} to=#{formatted_to} ---"

      client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

      ivr_url = Rails.application.routes.url_helpers.show_ivr_user_url(
        user,
        host: 'j-work.jp',
        protocol: 'https'
      )

      # Twilio API 実行
      client.calls.create(
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: formatted_to,
        url: ivr_url
      )

      Rails.logger.info "User ID: #{user.id} へのIVR発信に成功しました。to=#{formatted_to}"
    rescue => e
      # エラー時、実際に渡した formatted_to をログに残す
      Rails.logger.error "IVR発信エラー (User ID: #{user_id}): #{e.message} | 送信先Attempt: #{formatted_to} | 元番号: #{raw_tel.inspect}"
    end
  end
end