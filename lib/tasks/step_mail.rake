namespace :step_mail do
  desc "send scheduled step mails"
  task send: :environment do
    now = Time.current

    UserStepMail
      .where(sent_at: nil)
      .where("scheduled_at <= ?", now)
      .find_each do |step_mail|

      StepMailJob.perform_now(step_mail.id)
    end
  end
end