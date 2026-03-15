# app/jobs/call_user_job.rb
class CallUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user

    client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

    # 電話番号の整形（p:除去）
    to_number = user.tel
    to_number = to_number.sub(/^p:/, '') if to_number.start_with?('p:')

    # Twilioへ発信リクエスト
    client.calls.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: to_number,
      url: Rails.application.routes.url_helpers.ivr_user_url(user, host: 'nondisastrous-sheri-arabinosic.ngrok-free.dev')
    )
    
    logger.info "Sent IVR call request to User ID: #{user.id}"
  rescue => e
    logger.error "Twilio Call Error for User #{user_id}: #{e.message}"
  end
end