class CallUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return if user.nil? || user.tel.blank?

    # 1. 電話番号のクリーニング
    raw_tel = user.tel.to_s.strip
    raw_tel = raw_tel.sub(/^p:/, '')        # 先頭の "p:" を除去
    raw_tel = raw_tel.gsub(/[^\d+]/, '')    # 数字と+以外を除去

    formatted_to = nil
    if raw_tel.match?(/^\+81\d{9,10}$/)
      formatted_to = raw_tel
    elsif raw_tel.match?(/^0\d{9,10}$/)
      formatted_to = "+81#{raw_tel[1..-1]}"
    else
      Rails.logger.warn "User ID: #{user.id} の番号 (#{user.tel.inspect}) は無効な形式のためスキップします。raw_tel=#{raw_tel.inspect}"
      return
    end

    # 2. 発信処理
    begin
      client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

      # URLは固定してユーザーIDはクエリで渡す方式に変更
      ivr_url = Rails.application.routes.url_helpers.show_ivr_user_url(
        host: 'j-work.jp',
        protocol: 'https',
        user_id: user.id
      )

      client.calls.create(
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: formatted_to,
        url: ivr_url
      )

      Rails.logger.info "User ID: #{user.id} へのIVR発信に成功しました。to=#{formatted_to} URL=#{ivr_url}"
    rescue => e
      Rails.logger.error "IVR発信エラー (User ID: #{user_id}): #{e.message} to=#{formatted_to} raw_tel=#{raw_tel.inspect}"
    end
  end
end