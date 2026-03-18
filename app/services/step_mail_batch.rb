class StepMailBatch
  def self.run
    puts "=== StepMailBatch START ==="

    UserStepMail.where(sent_at: nil).find_each do |step_mail|
      StepMailService.run(step_mail)
    end

    puts "=== StepMailBatch END ==="
  end
end