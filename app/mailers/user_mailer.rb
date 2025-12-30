class UserMailer < ActionMailer::Base
  default from: "info@j-work.jp"

  def received_email(user)
    @user = user
    mail(
      from: @user.email,
      to: "info@j-work.jp",
      subject: "#{@user.name} から申し込みがありました。"
    )
  end

  def send_email(user)
    @user = user
    attachments.inline['LINE.png'] = File.read(
      Rails.root.join('app/assets/images/LINE.png')
    )
    mail(
      to: @user.email,
      subject: 'META広告よりお問い合わせありがとうございます。【Thank you for your inquiry from META Advertising.】'
    ) do |format|
      format.html
    end
  end

def contract_received_email(user)
  @user = user
  template =
    @user.hope_work == "Cleaner" ? "contract_received_cleaner" : "contract_received_driver"
  mail(
    to: "info@j-work.jp",
    subject: "J Workで契約同意がありました",
    template_name: template
  )
end

def contract_send_email(user)
  @user = user
  template =
    @user.hope_work == "Cleaner" ? "contract_send_cleaner" : "contract_send_driver"
  mail(
    to: @user.email,
    subject: "ご契約いただきありがとうございます。",
    template_name: template
  )
end

  def received_first_email(user)
    @user = user
    @user_url = "https://ri-plus.jp/users/#{user.id}"
    mail(
      to: "reply@ri-plus.jp",
      subject: "【#{@user.company}】契約発行通知"
    )
  end

  def send_first_email(user)
    @user = user
    @user_url = "https://ri-plus.jp/users/#{user.id}"
    mail(
      from: "info@j-work.jp",
      to: @user.email,
      subject: "契約締結のご案内"
    )
  end

  def received_start_email(user)
    @user = user
    @user_url = "https://ri-plus.jp/users/#{user.id}"
    mail(
      to: "reply@ri-plus.jp",
      subject: "【#{@user.company}】開始日発行通知"
    )
  end

  def send_start_email(user)
    @user = user
    @user_url = "https://ri-plus.jp/users/#{user.id}"
    mail(
      from: "info@j-work.jp",
      to: @user.email,
      subject: "株式会社Ri-Plus業務開始日のご案内"
    )
  end

  def new_comment_notification(comment)
    @comment = comment
    @user = comment.user
    @user_url = "https://ri-plus.jp/users/#{@user.id}"
    mail(
      to: "reply@ri-plus.jp",
      subject: "#{@user.company}のステータスが#{@comment.status}に更新されました"
    )
  end

  def welcome_email(user)
    @user = user
    attachments.inline['LINE.png'] = File.read(Rails.root.join('app/assets/images/LINE.png'))
    mail(
      to: @user.email,
      subject: 'METAよりおといあわせありがとうございます。'
    )
  end

  def followup_1_day(user)
    @user = user
    attachments.inline['LINE.png'] = File.read(Rails.root.join('app/assets/images/LINE.png'))
    mail(
      to: @user.email,
      subject: '📨 人気（にんき）No.1！高収入（こうしゅうにゅう）ドライバーのご紹介（しょうかい）'
    )
  end

  def followup_3_day(user)
    @user = user
    attachments.inline['LINE.png'] = File.read(Rails.root.join('app/assets/images/LINE.png'))
    mail(
      to: @user.email,
      subject: 'LINEへの登録はお済みですか？まずは面接を開始しましょう！'
    )
  end

  def followup_7_day(user)
    @user = user
    attachments.inline['LINE.png'] = File.read(Rails.root.join('app/assets/images/LINE.png'))
    mail(
      to: @user.email,
      subject: '📨 日本語（にほんご）が不安（ふあん）な方（かた）にもおすすめ！'
    )
  end

  def followup_15_day(user)
    @user = user
    attachments.inline['LINE.png'] = File.read(Rails.root.join('app/assets/images/LINE.png'))
    mail(
      to: @user.email,
      subject: 'LINEへの登録はお済みですか？月給40~70万円稼げるお仕事をご紹介'
    )
  end

  def followup_30_day(user)
    @user = user
    attachments.inline['LINE.png'] = File.read(Rails.root.join('app/assets/images/LINE.png'))
    mail(
      to: @user.email,
      subject: '【J Work】その後お仕事はお決まりでしょうか？'
    )
  end

  def followup_60_day(user)
    @user = user
    attachments.inline['LINE.png'] = File.read(Rails.root.join('app/assets/images/LINE.png'))
    mail(
      to: @user.email,
      subject: 'いまのお仕事に満足していますか？稼げるドライバー職をご紹介！'
    )
  end
end
