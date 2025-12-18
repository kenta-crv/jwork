class StepMailJob < ApplicationJob
  queue_as :default

  FOLLOWUP_METHODS = {
    1  => :followup_1_day,
    3  => :followup_3_day,
    7  => :followup_7_day,
    15 => :followup_15_day,
    30 => :followup_30_day,
    60 => :followup_60_day
  }

  def perform(user_step_mail_id)
    puts ">>> StepMailJob START id=#{user_step_mail_id} time=#{Time.current}"

    step_mail = UserStepMail.find_by(id: user_step_mail_id)
    return unless step_mail

    # ★ 最重要：二重送信防止（cron前提）
    return if step_mail.sent_at.present?

    # ステータス条件は今まで通り
    return unless step_mail.user.status.to_s.upcase == "SMS"

    mail_method = FOLLOWUP_METHODS[step_mail.mail_type.to_i]
    return unless mail_method

    # 念のため最新化
    step_mail.user.reload

    UserMailer.send(mail_method, step_mail.user).deliver_now

    # ★ cron前提なので sent_at のみ記録
    step_mail.update!(sent_at: Time.current)

    puts ">>> StepMailJob END id=#{user_step_mail_id} time=#{Time.current}"

  rescue => e
    Rails.logger.error("StepMailJob failed id=#{user_step_mail_id}: #{e.message}")
  end
end
