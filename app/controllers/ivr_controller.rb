class IvrController < ApplicationController
  # ログイン認証をスキップ（Twilioが外部からアクセスできるようにするため）
  skip_before_action :authenticate_admin!, raise: false
  skip_before_action :authenticate_user!, raise: false
  skip_before_action :verify_authenticity_token

  def show
    user = User.find(params[:id])
    
    # 開発環境ならngrok、それ以外（本番）なら j-work.jp を自動で切り替える
    app_host = (Rails.env.development? && !ENV['APP_HOST']) ? 'nondisastrous-sheri-arabinosic.ngrok-free.dev' : 'j-work.jp'

    render xml: <<~XML
      <Response>
        <Gather numDigits="1" action="#{handle_choice_ivr_user_url(user, host: app_host, protocol: 'https')}" method="POST" timeout="10">
          <Say voice="alice" language="en-US">
            Thank you for applying for a job at J Work.
            This call is for applicants who have not yet registered their LINE account.
            If you would like to schedule an interview, press 1.
            If you have already found a job and do not need further guidance, press 2.
          </Say>
          <Say voice="alice" language="ja-JP">
            先日はジェイワークの求人にご応募いただきありがとうございます。
            このお電話は、応募後にラインアカウントにご登録いただいていない方にご連絡しています。
            お仕事の面接を希望する場合は1、
            お仕事がすでに決まり案内が不要な場合は2を押してください。
          </Say>
          <Pause length="2"/>
        </Gather>

        <Say voice="alice" language="ja-JP">
          入力が確認できませんでした。失礼いたします。
        </Say>

        <Hangup/>
      </Response>
    XML
  end

  def handle_choice
    user = User.find(params[:id])
    choice = params[:Digits]
    
    logger.info "User ID: #{user.id}, Pressed Digits: #{choice}"

    # ステータス更新とSMS送信を実行
    begin
      # ステータスを適切に更新（choice_to_statusは下部に定義）
      user.update!(status: choice_to_status(choice))
      
      # SMS送信を有効化
      send_sms(user, choice) 
      logger.info "SMS sent for User ID: #{user.id}"
    rescue => e
      logger.error "Update/SMS Error: #{e.message}"
    end

    # 応答メッセージの作成
    message_en, message_jp = case choice
              when '1'
                ["Thank you. We will send you a LINE URL via SMS shortly. Please join LINE and follow the instructions. Goodbye.",
                 "ありがとうございます。お仕事の面接はラインで行っております。この後ショートメッセージでラインのURLをお送りしますので、ラインにご入室いただき自動案内に沿って面接日を決定してください。"]
              when '2'
                ["Thank you very much. If you are looking for a job again in the future, please use our service. Goodbye.",
                 "ありがとうございました。またお仕事を探される際はご利用ください。失礼いたします。"]
              else
                ["We could not confirm your input. Goodbye.",
                 "入力を確認できませんでした。失礼いたします。"]
              end

    render xml: <<~XML
      <Response>
        <Say voice="alice" language="en-US">#{message_en}</Say>
        <Say voice="alice" language="ja-JP">#{message_jp}</Say>
        <Hangup/>
      </Response>
    XML
  end

  private

  def choice_to_status(choice)
    case choice
    when '1'
      'invited_line' # 必要に応じてモデルのenum定義に合わせて変更してください
    when '2'
      'already_decided_ng'
    else
      'unknown'
    end
  end

  def send_sms(user, choice)
    client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )

    # 電話番号の整形
    to_number = user.tel
    to_number = to_number.sub(/^p:/, '') if to_number.start_with?('p:')

    # LINEのURLなどは適宜変更してください
    message = case choice
              when '1'
                "面接はLINEで行います。こちらから登録してください: https://j-work.jp/line"
              when '2'
                "ジェイワークです。ご確認ありがとうございました。またの機会によろしくお願いいたします。"
              else
                "ご確認ありがとうございました。"
              end

    client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: to_number,
      body: message
    )
  end
end