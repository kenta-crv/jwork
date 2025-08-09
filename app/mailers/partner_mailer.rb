class PartnerMailer < ActionMailer::Base
  default from: "info@j-work.jp"
  def received_email(partner)
    @partner = partner
    mail from: partner.email
    mail to: "info@j-work.jp"
    mail(subject: "#{partner.company} から申し込みがありました。") do |format|
      format.text
    end
  end

  def send_email(partner)
    @partner = partner
    mail to: partner.email
    mail(subject: '外国人転職『J Work』にご登録頂きありがとうございます。') do |format|
      format.text
    end
  end

  def contract_received_email(partner)
    @partner = partner
    mail to: "info@j-work.jp"
    mail(subject: 'J Work DBで契約同意がありました') do |format|
      format.text
    end
  end

  def contract_send_email(partner)
    @partner = partner
    mail to: partner.email
    mail(subject: '『J Work DB』をご契約いただきありがとうございます。') do |format|
      format.text
    end
  end

  def received_first_email(partner)
    @partner = partner
    @partner_url = "https://j-work.jp/partners/#{partner.id}"
    mail(to: "reply@ri-plus.jp", subject: "【#{@partner.company}】契約発行通知")
  end

  def send_first_email(partner)
    @partner = partner
    @partner_url = "https://j-work.jp/partners/#{partner.id}"
    mail(from:"info@j-work.jp", to: @partner.email, subject: "契約締結のご案内")
  end

  def received_start_email(partner)
    @partner = partner
    @partner_url = "https://j-work.jp/partners/#{partner.id}"
    mail(to: "reply@ri-plus.jp", subject: "【#{@partner.company}】開始日発行通知")
  end

  def send_start_email(partner)
    @partner = partner
    @partner_url = "https://j-work.jp/partners/#{partner.id}"
    mail(from:"info@j-work.jp", to: @partner.email, subject: "J Work DB業務開始日のご案内")
  end

  def new_comment_notification(comment)
    @comment = comment
    @partner = comment.partner
    @partner_url = "https://j-work.jp/partners/#{@partner.id}"
    mail to: "reply@ri-plus.jp"
    mail(subject: "#{@partner.company}のステータスが#{@comment.status}に更新されました") do |format|
      format.text
    end
  end

  def edit_script_notification(script)
    @script = script
    @partner = script.partner
    @partner_url = "https://j-work.jp/partners/#{@partner.id}/script"
    mail to: "reply@ri-plus.jp"
    mail(subject: "#{@partner.company}よりスクリプト編集が実行されました") do |format|
      format.text
    end
  end
end
