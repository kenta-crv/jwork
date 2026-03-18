class CallUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    # 1. 時間帯判定ロジック (一時的にコメントアウト)
    # now = Time.current
    # hour = now.hour
    #
    # if hour >= 20 || hour < 11
    #   scheduled_time = hour >= 20 ? now.tomorrow.change(hour: 11, min: 0) : now.change(hour: 11, min: 0)
    #   Rails.logger.info "夜間禁止時間帯のため、User ID: #{user_id} への発信を #{scheduled_time} に延期します。"
    #   CallUserJob.set(wait_until: scheduled_time).perform_later(user_id)
    #   return
    # end

    user = User.find_by(id: user_id)
    return if user.nil? || user.tel.blank?

    # 2. 電話番号のクリーニングと日本番号の判定
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

    # 3. 発信処理
    begin
      client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
      
      ivr_url = "https://j-work.jp/users/#{user.id}/show_ivr"

      client.calls.create(
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: formatted_to,
        url: ivr_url
      )
      Rails.logger.info "User ID: #{user.id} へのIVR発信に成功しました。宛先: #{formatted_to}"
    rescue => e
      Rails.logger.error "IVR発信エラー (User ID: #{user_id}): #{e.message}"
    end
  end
end