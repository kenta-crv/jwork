class CallUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user

    client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

    # 他に影響を与えないよう、ここでドメインを直接判別する
    # Socket.gethostname などで判別も可能ですが、一番確実なのは環境変数
    app_host = ENV['APP_HOST'] 

    # もし環境変数が設定されていない場合でも動くように、
    # 本番サーバーのドメインをここに直接書いてしまう（開発環境以外の場合）
    if Rails.env.development? && !ENV['APP_HOST']
      # あなたの手元（ローカル）で動かす時は ngrok
      app_host = 'nondisastrous-sheri-arabinosic.ngrok-free.dev'
    else
      # 本番サーバーで動いている時は、実際のドメインを直接指定
      app_host = 'あなたの本番ドメイン.com' # ← ここに実際のドメインを書いてください
    end

    ivr_url = Rails.application.routes.url_helpers.ivr_user_url(
      user, 
      host: app_host, 
      protocol: 'https'
    )

    client.calls.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: user.tel.sub(/^p:/, ''),
      url: ivr_url
    )
    
    Rails.logger.info "Sent IVR call via #{app_host}"
  rescue => e
    Rails.logger.error "IVR Job Error: #{e.message}"
    raise e
  end
end