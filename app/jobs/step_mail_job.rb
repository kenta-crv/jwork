class StepMailJob < ApplicationJob
  queue_as :default

  FOLLOWUP_METHODS = {
    1 => :followup_1_day,
    3 => :followup_3_day,
    7 => :followup_7_day,
    15 => :followup_15_day,
    30 => :followup_30_day,
    60 => :followup_60_day
  }

  def perform(user_step_mail_id)
    puts ">>> StepMailJob START id=#{user_step_mail_id} time=#{Time.current}"

    step_mail = UserStepMail.find_by(id: user_step_mail_id)
    return unless step_mail && step_mail.pending?
    
    # 【修正箇所】大文字に変換して比較する (大文字・小文字の不一致を回避)
    return unless step_mail.user.status.upcase == "SMS"

    mail_method = FOLLOWUP_METHODS[step_mail.mail_type.to_i]
    if mail_method
      # deliver_now 実行前にユーザーレコードを確実に最新の状態にする
      step_mail.user.reload if step_mail.user.status.downcase == "sms"
      
      UserMailer.send(mail_method, step_mail.user).deliver_now
      step_mail.update(sent_at: Time.current, status: "sent")
    end

    puts ">>> StepMailJob END id=#{user_step_mail_id} time=#{Time.current}"

  rescue => e
    # エラー発生時は status を 'failed' に更新し、ログに出力
    step_mail.update(status: "failed") if step_mail.present?
    Rails.logger.error("StepMailJob failed: #{e.message}")
  end
end