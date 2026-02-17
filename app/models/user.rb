class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :comments, dependent: :destroy
  has_many :alcohols, dependent: :destroy
  has_many :inspections, dependent: :destroy
  has_many :journals, dependent: :destroy
  mount_uploader :image_1, ImagesUploader
  mount_uploader :image_2, ImagesUploader
  mount_uploader :image_3, ImagesUploader
  mount_uploader :image_4, ImagesUploader
  after_create :schedule_step_mails
  after_update :schedule_step_mails_if_sms
  #after_create :send_welcome_sms_async
  has_many :user_step_mails, dependent: :destroy

  STEP_MAILS = [1, 3, 7, 15, 30, 60]

    def interview_request_text
    <<~TEXT
      お世話になっております。
      以下人材の面接をお願いしたく存じます。

      名前：#{name}
      生年月日：#{age}
      住まい：#{address}
      お仕事：#{work_now}
      ビザ種別：#{which_visa}
      日本滞在：#{visiting_in_japan}
      開始希望日：#{start}
      面接希望日：

      以上、よろしくお願い致します。
    TEXT
  end

  def contract_request_text
    <<~TEXT
      お疲(つか)れ様(さま)です。
      先日(せんじつ)は面接(めんせつ)対応(たいおう)をいただきありがとうございました。
      以下(いか)、手続(てつづ)きを進(すす)めるために
      まずは契約(けいやく)の締結(ていけつ)を行(おこな)います。

      以下URLよりアクセスいただき、
      契約を完了(かんりょう)してください。
    TEXT
  end
  
  private

  def schedule_step_mails
    # 登録時メール
    UserMailer.welcome_email(self).deliver_later

    # SMSステータスならフォローメール予約
    schedule_followup_mails if status == "sms" # ★ status は小文字で比較すべき
  end

  def schedule_step_mails_if_sms
    return unless saved_change_to_status?
    return unless status == "sms" # ★ status は小文字で比較すべき

    schedule_followup_mails
  end

  def schedule_followup_mails
    STEP_MAILS.each do |days|
      mail_type = "#{days}_day"
      # 同じ種類の予約がすでにある場合はスキップ
      next if user_step_mails.exists?(mail_type: mail_type, status: "pending")

      step_mail = user_step_mails.create!(
        mail_type: mail_type,
        scheduled_at: Time.current + days.days,
        status: "pending"
      )
      #StepMailJob.set(wait_until: step_mail.scheduled_at).perform_later(step_mail.id)
    end
  end


  def send_welcome_sms_async
    SendSmsJob.perform_later(self.id)
  end

  scope :visa_group_eq, ->(value = nil) {
    return all if value.to_i != 1
    where("work_range LIKE ? OR work_range LIKE ? OR work_range LIKE ? OR work_range LIKE ? OR work_range LIKE ? OR work_range LIKE ?", 
          "%永住%", "%Permanent%", "%定住%", "%Long-term%", "%配偶者%", "%Spouse%")
  }

  def self.ransackable_scopes(_auth_object = nil)
    [:visa_group_eq]
  end

  # ★★★ 修正箇所: enum の定義を慣習通り、キーと値を小文字に統一 (DBに小文字で保存される) ★★★
  enum status: { 
    sms: "sms",                 # DBに "sms" が保存される
    line: "line",               # DBに "line" が保存される
    recruitment: "recruitment", 
    interviewed: "interviewed", # 括弧書きの部分もDBに保存する値として小文字に統一
    interview_ng: "interview_ng", 
    not_join: "not_join",
    ng: "ng"  
  }
end