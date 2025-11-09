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
    step_mail = UserStepMail.find_by(id: user_step_mail_id)
    return unless step_mail && step_mail.pending?
    return unless step_mail.user.status == "SMS"

    mail_method = FOLLOWUP_METHODS[step_mail.mail_type.to_i]
    if mail_method
      UserMailer.send(mail_method, step_mail.user).deliver_now
      step_mail.update(sent_at: Time.current, status: "sent")
    end
  rescue => e
    step_mail.update(status: "failed")
    Rails.logger.error("StepMailJob failed: #{e.message}")
  end
end
