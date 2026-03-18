class StepMailService
  FOLLOWUP_METHODS = {
    1  => :followup_1_day,
    3  => :followup_3_day,
    7  => :followup_7_day,
    15 => :followup_15_day,
    30 => :followup_30_day,
    60 => :followup_60_day
  }

  def self.run(step_mail)
    puts "---- id=#{step_mail.id} START"

    if step_mail.sent_at.present?
      puts "skip: already sent"
      return
    end

    status = step_mail.user.status&.upcase

    unless status.nil? || status == "sms"
      puts "skip: status=#{step_mail.user.status}"
      return
    end

    mail_method = FOLLOWUP_METHODS[step_mail.mail_type.to_i]

    unless mail_method
      puts "skip: invalid mail_type=#{step_mail.mail_type}"
      return
    end

    puts "sending mail... user_id=#{step_mail.user.id}"

    step_mail.user.reload

    UserMailer.send(mail_method, step_mail.user).deliver_now

    step_mail.update!(sent_at: Time.current)

    puts "done id=#{step_mail.id}"
  rescue => e
    Rails.logger.error("StepMailService failed id=#{step_mail.id}: #{e.message}")
    puts "ERROR: #{e.message}"
  end
end