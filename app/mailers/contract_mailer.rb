class ContractMailer < ActionMailer::Base
  default from: "info@j-work.jp"
  def received_email(contract)
    @contract = contract
    mail to: "info@j-work.jp"
    mail(subject: '外国人転職の『J Work』にお問い合わせがありました') do |format|
      format.text
    end
  end

  def send_email(contract)
    @contract = contract
    mail to: contract.email
    mail(subject: '外国人転職の『J Work』にお問い合わせ頂きありがとうございます。') do |format|
      format.text
    end
  end

  def contract_received_email(contract)
    @contract = contract
    mail to: "info@j-work.jp"
    mail(subject: '外国人転職の『J Work』約款へ同意いただきありがとうございました。') do |format|
      format.text
    end
  end

  def contract_send_email(contract)
    @contract = contract
    mail to: contract.email
    mail(subject: '外国人転職の『J Work』約款へ同意いただきありがとうございました。') do |format|
      format.text
    end
  end

  def received_first_email(contract)
    @contract = contract
    @contract_url = "https://j-work.jp/contracts/#{contract.id}"
    mail(to: "info@j-work.jp", subject: "【#{@contract.co}】契約発行通知")
  end

  def send_first_email(contract)
    @contract = contract
    @contract_url = "https://j-work.jp/contracts/#{contract.id}"
    mail(from:"info@j-work.jp", to: @contract.email, subject: "契約締結のご案内")
  end

  def new_comment_notification(comment)
    @comment = comment
    @contract = comment.contract
    @contract_url = "https://j-work.jp/contracts/#{@contract.id}"
    mail to: "reply@ri-plus.jp"
    mail(subject: "#{@contract.co}のステータスが#{@comment.status}に更新されました") do |format|
      format.text
    end
  end

end
