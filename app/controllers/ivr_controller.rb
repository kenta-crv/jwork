class IvrController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    user = User.find(params[:id])
    render xml: <<~XML
      <Response>
        <Gather numDigits="1" action="#{handle_choice_ivr_url(user)}" method="POST">
          <Say>1. サポート 2. 営業</Say>
        </Gather>
        <Say>入力がありませんでした。さようなら。</Say>
      </Response>
    XML
  end

  def handle_choice
    user = User.find(params[:id])
    choice = params[:Digits]

    # ステータス更新
    user.update(status: choice_to_status(choice))

    # SMS送信
    send_sms(user, choice)

    # 次の質問または終了メッセージ
    render xml: <<~XML
      <Response>
        <Say>ご回答ありがとうございました。さようなら。</Say>
        <Hangup/>
      </Response>
    XML
  end

  private

  def choice_to_status(choice)
    case choice
    when '1'
      'support'
    when '2'
      'sales'
    else
      'unknown'
    end
  end

  def send_sms(user, choice)
    client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
    message = case choice
              when '1' then "サポート担当より後ほどご連絡します。"
              when '2' then "営業担当より後ほどご連絡します。"
              else "ご選択ありがとうございました。"
              end

    client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: user.tel,
      body: message
    )
  end
end