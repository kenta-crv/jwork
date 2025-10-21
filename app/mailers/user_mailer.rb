class UserMailer < ActionMailer::Base
  default from: "info@j-work.jp"
  def received_email(user)
    @user = user
    mail from: user.email
    mail to: "info@j-work.jp"
    mail(subject: "#{user.name} から申し込みがありました。") do |format|
      format.text
    end
  end

  def send_email(user)
    @user = user
    mail to: user.email
    mail(subject: 'ご登録頂きありがとうございます。') do |format|
      format.text
    end
  end

  def contract_received_email(user)
    @user = user
    mail to: "info@j-work.jp"
    mail(subject: 'J Workで契約同意がありました') do |format|
      format.text
    end
  end

  def contract_send_email(user)
    @user = user
    mail to: user.email
    mail(subject: 'ご契約いただきありがとうございます。') do |format|
      format.text
    end
  end

  def received_first_email(user)
    @user = user
    @user_url = "https://ri-plus.jp/users/#{user.id}"
    mail(to: "reply@ri-plus.jp", subject: "【#{@user.company}】契約発行通知")
  end

  def send_first_email(user)
    @user = user
    @user_url = "https://ri-plus.jp/users/#{user.id}"
    mail(from:"info@j-work.jp", to: @user.email, subject: "契約締結のご案内")
  end

  def received_start_email(user)
    @user = user
    @user_url = "https://ri-plus.jp/users/#{user.id}"
    mail(to: "reply@ri-plus.jp", subject: "【#{@user.company}】開始日発行通知")
  end

  def send_start_email(user)
    @user = user
    @user_url = "https://ri-plus.jp/users/#{user.id}"
    mail(from:"info@j-work.jp", to: @user.email, subject: "株式会社Ri-Plus業務開始日のご案内")
  end

  def new_comment_notification(comment)
    @comment = comment
    @user = comment.user
    @user_url = "https://ri-plus.jp/users/#{@user.id}"
    mail to: "reply@ri-plus.jp"
    mail(subject: "#{@user.company}のステータスが#{@comment.status}に更新されました") do |format|
      format.text
    end
  end
end
