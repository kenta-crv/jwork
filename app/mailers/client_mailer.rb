class ClientMailer < ActionMailer::Base
  default from: "info@j-work.jp"
  def received_email(client)
    @client = client
    mail from: client.email
    mail to: "info@j-work.jp"
    mail(subject: '#{client.company} がサイト登録しました。') do |format|
      format.text
    end
  end

  def send_email(client)
    @client = client
    mail to: client.email
    mail(subject: '外国人転職『J Work』にご登録頂きありがとうございます。') do |format|
      format.text
    end
  end

  def contract_received_email(client)
    @client = client
    mail to: "info@ri-plus.jp"
    mail(subject: '株式会社Ri-Plusで契約同意がありました') do |format|
      format.text
    end
  end

  def contract_send_email(client)
    @client = client
    mail to: client.email
    mail(subject: '『アポ匠』をご契約いただきありがとうございます。') do |format|
      format.text
    end
  end

  def received_first_email(client)
    @client = client
    @client_url = "https://ri-plus.jp/clients/#{client.id}"
    mail(to: "reply@ri-plus.jp", subject: "【#{@client.company}】契約発行通知")
  end

  def send_first_email(client)
    @client = client
    @client_url = "https://ri-plus.jp/clients/#{client.id}"
    mail(from:"info@ri-plus.jp", to: @client.email, subject: "契約締結のご案内")
  end

  def received_start_email(client)
    @client = client
    @client_url = "https://ri-plus.jp/clients/#{client.id}"
    mail(to: "reply@ri-plus.jp", subject: "【#{@client.company}】開始日発行通知")
  end

  def send_start_email(client)
    @client = client
    @client_url = "https://ri-plus.jp/clients/#{client.id}"
    mail(from:"info@ri-plus.jp", to: @client.email, subject: "株式会社Ri-Plus業務開始日のご案内")
  end

  def new_comment_notification(comment)
    @comment = comment
    @client = comment.client
    @client_url = "https://ri-plus.jp/clients/#{@client.id}"
    mail to: "reply@ri-plus.jp"
    mail(subject: "#{@client.company}のステータスが#{@comment.status}に更新されました") do |format|
      format.text
    end
  end

  def edit_script_notification(script)
    @script = script
    @client = script.client
    @client_url = "https://ri-plus.jp/clients/#{@client.id}/script"
    mail to: "reply@ri-plus.jp"
    mail(subject: "#{@client.company}よりスクリプト編集が実行されました") do |format|
      format.text
    end
  end
end
