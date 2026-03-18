class CallUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user

    client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

    app_host = (Rails.env.development? && !ENV['APP_HOST']) ? 'nondisastrous-sheri-arabinosic.ngrok-free.dev' : 'j-work.jp'
    ivr_url = "https://#{app_host}/users/#{user.id}/show_ivr"

    to_number = user.tel.sub(/^p:/, '')
    client.calls.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: to_number,
      url: ivr_url
    )
    
    Rails.logger.info "IVR call sent to: #{user.tel} URL: #{ivr_url}"
  rescue => e
    Rails.logger.error "IVR Job Error: #{e.message}"
    raise e
  end
end