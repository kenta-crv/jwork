namespace :step_mail do
  desc "毎日19:00に予定されたステップメールを送信 (status: nil または sms を対象とする)"
  task send_scheduled: :environment do
    puts ">>> StepMail Task Start: #{Time.current}"

    # 未送信かつ予定時刻を過ぎたレコードを取得
    mails = UserStepMail.where(sent_at: nil).where("scheduled_at <= ?", Time.current)

    mails.find_each do |mail|
      user = mail.user

      # 判定ロジック: status が nil でも "sms" でもない（＝他ステータスに変わった）なら中断
      unless user.status.nil? || user.status == "sms"
        puts "Skipped mail_id=#{mail.id}: User(#{user.id}) status is #{user.status}"
        next
      end

      # メソッドの特定
      followup_methods = {
        1  => :followup_1_day,
        3  => :followup_3_day,
        7  => :followup_7_day,
        15 => :followup_15_day,
        30 => :followup_30_day,
        60 => :followup_60_day
      }
      mail_method = followup_methods[mail.mail_type.to_i]

      next unless mail_method

      begin
        # 実際にメールを送信
        UserMailer.send(mail_method, user).deliver_now
        
        # 送信完了を記録
        mail.update!(sent_at: Time.current)
        puts "Successfully sent: MailID=#{mail.id}, UserID=#{user.id}, Type=#{mail.mail_type}"
      rescue => e
        Rails.logger.error "StepMail Error id=#{mail.id}: #{e.message}"
      end
    end

    puts ">>> StepMail Task End: #{Time.current}"
  end
end