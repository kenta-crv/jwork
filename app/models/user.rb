class User < ApplicationRecord
  # Devise, Associations
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :comments, dependent: :destroy
  has_many :alcohols, dependent: :destroy
  has_many :inspections, dependent: :destroy
  has_many :journals, dependent: :destroy
  has_many :user_step_mails, dependent: :destroy

  mount_uploader :image_1, ImagesUploader
  mount_uploader :image_2, ImagesUploader
  mount_uploader :image_3, ImagesUploader
  mount_uploader :image_4, ImagesUploader

  after_create :schedule_step_mails
  after_update :schedule_step_mails_if_sms

  STEP_MAILS = [1, 3, 7, 15, 30, 60]

  enum status: { 
    sms: "sms",
    line: "line",
    interviewed: "interviewed", 
    final_interview_adjustment: "final_interview_adjustment",
    contract_wait: "contract_wait",
    started_operation: "started_operation",
    interview_ng: "interview_ng", 
    not_join: "not_join",
    ng: "ng",
    invited_line: "invited_line",
    already_decided_ng: "already_decided_ng",
    recruitment: "recruitment", 
  }

  def status_label
    I18n.t("activerecord.attributes.user.status.#{status}")
  end

  def interview_request_text
    <<~TEXT
      お世話になっております。
      以下人材の面接をお願いしたく存じます。

      名前：#{name}
      性別：#{gender}
      生年月日：#{age}
      住まい：#{address}
      経験則: #{experience}
      ビザ種別：#{work_range}
      日本滞在：#{past_year}
      開始希望日：#{period}
      日本語レベル：#{speak_japanese}
      面接希望日：

      以上、よろしくお願い致します。
    TEXT
  end

  def contract_request_text
    <<~TEXT
      おつかれさまです。今回採用したお仕事の契約書を締結します。
      以下URLよりアクセスし、手続きを完了してください。
      ①住所・証明書アップロード・振込先入力
      https://j-work.jp/users/#{id}/edit
      ②契約の締結
      https://j-work.jp/users/#{id}/conclusion
      以上、よろしくお願い致します。

      Thank you for your hard work. We are now entering into a contract for the position you have been hired for.
      Please access the URL below and complete the procedure.
      1. Upload address and certificates and enter bank details
      2. Enter contract
      Thank you for your cooperation.
    TEXT
  end

  scope :visa_group_eq, ->(value = nil) {
    return all if value.to_i != 1
    where("work_range LIKE ? OR work_range LIKE ? OR work_range LIKE ? OR work_range LIKE ? OR work_range LIKE ? OR work_range LIKE ?", 
          "%永住%", "%Permanent%", "%定住%", "%Long-term%", "%配偶者%", "%Spouse%")
  }

  def self.ransackable_scopes(_auth_object = nil)
    [:visa_group_eq]
  end

  private

  def schedule_step_mails
    # 登録直後のウェルカムメール
    UserMailer.welcome_email(self).deliver_now

    # ステータスが nil または sms なら予約作成
    if status.nil? || status == "sms"
      schedule_followup_mails
    end
  end

  def schedule_step_mails_if_sms
    # ステータスに変更がない場合は何もしない
    return unless saved_change_to_status?

    # 変更後のステータスが nil または sms なら予約作成
    if status.nil? || status == "sms"
      schedule_followup_mails
    end
  end

  def schedule_followup_mails
    STEP_MAILS.each do |days|
      mail_type = days.to_s
      # 未送信の同じタイプが既にあれば二重作成防止
      next if user_step_mails.exists?(mail_type: mail_type, sent_at: nil)

      user_step_mails.create!(
        mail_type: mail_type,
        scheduled_at: Time.current + days.days
      )
    end
  end
end