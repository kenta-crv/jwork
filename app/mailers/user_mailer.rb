class UserMailer < ActionMailer::Base
  default from: "info@tele-match.net"
  def received_email(user)
    @user = user
    mail from: user.email
    mail to: "info@tele-match.net"
    mail(subject: 'アポインターの登録がありました') do |format|
      format.text
    end
  end

  def send_email(user)
    @user = user
    mail to: user.email
    mail(subject: 'テレコンに登録頂きありがとうございます｜株式会社Ri-Plus') do |format|
      format.text
    end
  end

  def offer_email(user)
    @user = user
    @edit_url = edit_user_url(@user)
    mail(to: user.email, subject: '音声面接結果のご案内')
  end

  def reject_email(user)
    @user = user
    mail(to: user.email, subject: '音声面接結果のご案内')
  end

  def second_received_email(user)
    @user = user
    mail(to: "info@tele-match.net", subject: "#{@user.name}さんが契約に同意しました。")
  end

  def second_send_email(user)
    @user = user
    mail(to: user.email, subject: '契約に同意いただきありがとうございます。')
  end
end
