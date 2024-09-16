class UserMailer < ActionMailer::Base
  default from: "info@j-work.jp"
  def received_email(user)
    @user = user
    mail from: user.email
    mail to: "info@j-work.jp"
    mail(subject: "#{user.name} さんがサイト登録を完了しました。") do |format|
      format.text
    end
  end

  def send_email(user)
    @user = user
    mail to: user.email
    mail(subject: '外国人専門転職『J Work』にご利用頂きありがとうございます。') do |format|
      format.text
    end
  end

  #def offer_email(user)
   # @user = user
    #@edit_url = edit_user_url(@user)
   # mail(to: user.email, subject: '音声面接結果のご案内')
  #end

  #def reject_email(user)
   # @user = user
    #mail(to: user.email, subject: '音声面接結果のご案内')
  #end

  def second_received_email(user)
    @user = user
    mail(to: "info@j-work.jp", subject: "#{@user.name}さんが契約に同意しました。")
  end

  def second_send_email(user)
    @user = user
    mail(to: user.email, subject: '契約に同意いただきありがとうございます。')
  end
end
