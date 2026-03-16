class CallUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user

    client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

    # 本番ドメインを直接指定。ENV['APP_HOST'] があれば優先、なければ直書き
    app_host = ENV['APP_HOST'] || 'j-work.jp'
    
    # routes.rb の定義 (users/:id/show_ivr) に合わせた絶対URLを生成
    # これなら show_ivr_user_url といったメソッド名の混乱に左右されません
    ivr_url = "https://#{app_host}/users/#{user.id}/show_ivr"

    client.calls.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: user.tel.sub(/^p:/, ''),
      url: ivr_url
    )
    
    Rails.logger.info "Sent IVR call via: #{ivr_url}"
  rescue => e
    Rails.logger.error "IVR Job Error: #{e.message}"
    raise e
  end
end