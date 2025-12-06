class SendSmsJob < ApplicationJob
  queue_as :default

def perform(user_id)
  user = User.find(user_id)
  
  # 先頭に "p:" がある場合だけ削除
  tel = user.tel.start_with?("p:") ? user.tel[2..-1] : user.tel

  client = Twilio::REST::Client.new(
    ENV['TWILIO_ACCOUNT_SID'],
    ENV['TWILIO_AUTH_TOKEN']
  )
  client.messages.create(
    from: ENV['TWILIO_PHONE_NUMBER'],
    to: tel,
    body: "#{user.name}さん！Thank you for choosing J Work, a job search site for foreigners. https://lin.ee/gIX2fUT We are introducing our jobs on LINE, so please use LINE and send us a message."
  )
end

end
