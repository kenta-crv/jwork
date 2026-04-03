class SendSmsJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return if user.nil? || user.tel.blank?
    
    # 先頭に "p:" がある場合だけ削除
    raw_tel = user.tel.start_with?("p:") ? user.tel[2..-1] : user.tel
    # 数字以外（ハイフンなど）を除去
    raw_tel = raw_tel.gsub(/[^\d]/, '')

    # ★重要：090... を +8190... に変換するロジック（IVRの成功パターンを移植）
    if raw_tel.match?(/^0\d{9,10}$/)
      to_number = "+81#{raw_tel[1..-1]}"
    else
      to_number = raw_tel # すでに+81がついている場合など
    end

    client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )

    client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: to_number,
      body: "#{user.name}さん！Thank you for choosing J Work, a job search site for foreigners. https://lin.ee/gIX2fUT We are introducing our jobs on LINE, so please use LINE and send us a message."
    )
  rescue => e
    Rails.logger.error "SMS送信失敗(User:#{user_id}): #{e.message}"
  end
end