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
    # ★ 修正: レコードの存在のみを確認 (pending? チェックを削除)
    return unless step_mail 

    # ステータスチェック（これは以前の修正のまま維持）
    return unless step_mail.user.status.upcase == "SMS"

    mail_method = FOLLOWUP_METHODS[step_mail.mail_type.to_i]
    if mail_method
      # deliver_now 実行前にユーザーレコードを確実に最新の状態にする
      step_mail.user.reload if step_mail.user.status.downcase == "sms"
      
      UserMailer.send(mail_method, step_mail.user).deliver_now
      
      # ★ 修正: status: "sent" への更新を削除し、sent_at の記録のみを残す
      step_mail.update(sent_at: Time.current) 
    end

    puts ">>> StepMailJob END id=#{user_step_mail_id} time=#{Time.current}"

  rescue => e
    # エラー発生時の status 変更ロジックを削除
    Rails.logger.error("StepMailJob failed: #{e.message}")
  end
end