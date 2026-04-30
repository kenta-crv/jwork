# app/jobs/send_sms_job.rb
class SendSmsJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return if user.nil? || user.tel.blank?

    # 先頭に "p:" がある場合だけ削除
    raw_tel = user.tel.to_s.strip.sub(/^p:/, '')

    # 数字と + 以外を除去
    raw_tel = raw_tel.gsub(/[^\d+]/, '')

    # 個別送信と同じルールで +81 に変換
    to_number =
      if raw_tel.match?(/^0\d{9,11}$/)       # 例: 08012345678
        "+81#{raw_tel[1..-1]}"
      elsif raw_tel.match?(/^81\d{9,11}$/)   # 例: 818012345678
        "+#{raw_tel}"
      elsif raw_tel.start_with?('+')          # すでに +81 形式
        raw_tel
      else
        raw_tel
      end

    client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )

    client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: to_number,
      body: "Thank you for your inquiry about our job. Contact us via LINE: https://lin.ee/yVI3ClY"
    )
  rescue => e
    Rails.logger.error "SMS送信失敗(User:#{user_id}): #{e.message}"
  end
end