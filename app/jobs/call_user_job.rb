class CallUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user

    client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

    # 本番は j-work.jp を固定で使用（開発環境ならngrok）
    app_host = (Rails.env.development? && !ENV['APP_HOST']) ? 'nondisastrous-sheri-arabinosic.ngrok-free.dev' : 'j-work.jp'
    
    # 先ほどコンソールで成功したURL構造を直接指定します
    ivr_url = "https://#{app_host}/users/#{user.id}/show_ivr"

    client.calls.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: user.tel.sub(/^p:/, ''),
      url: ivr_url
    )
    
    Rails.logger.info "IVR call sent to: #{user.tel} URL: #{ivr_url}"
  rescue => e
    Rails.logger.error "IVR Job Error: #{e.message}"
    raise e
  end
end