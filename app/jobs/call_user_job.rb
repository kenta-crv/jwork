class CallUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

    client.calls.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: user.tel,
      url: Rails.application.routes.url_helpers.ivr_url(user) # 後述するIVRルート
    )
  end
end