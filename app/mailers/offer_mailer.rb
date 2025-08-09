class OfferMailer < ActionMailer::Base
  default from: "info@j-work.jp"

  def client_interview_received_email(offer, client)
    @offer = offer
    @client = client
    @user = offer.user  # アソシエーションから user を取得

    mail(
      from: @client.email,
      to: "info@j-work.jp",
      subject: "#{@client.company}が#{@user.name}に面接打診を送信しました｜J Work"
    ) do |format|
      format.text
    end
  end

  def client_interview_admin_email(offer, client)
    @offer = offer
    @client = client
    @user = offer.user  # アソシエーションから user を取得

    mail(
      from: "info@j-work.jp",
      to: "info@j-work.jp",
      subject: "#{@client.company}から#{@user.name}に面接打診がありました。"
    ) do |format|
      format.text
    end
  end
end
