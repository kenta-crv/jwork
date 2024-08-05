# app/mailers/worker_mailer.rb
class WorkerMailer < ActionMailer::Base
  default from: "info@ri-plus.jp"
  def received_email(worker)
    @worker = worker
    mail from: worker.email
    mail to: "info@ri-plus.jp"
    mail(subject: 'アポインターの登録がありました') do |format|
      format.text
    end
  end

  def send_email(worker)
    @worker = worker
    mail to: worker.email
    mail(subject: 'テレコンに登録頂きありがとうございます｜株式会社Ri-Plus') do |format|
      format.text
    end
  end

  def offer_email(worker)
    @worker = worker
    @edit_url = edit_worker_url(@worker)
    mail(to: worker.email, subject: '音声面接結果のご案内')
  end

  def reject_email(worker)
    @worker = worker
    mail(to: worker.email, subject: '音声面接結果のご案内')
  end

  def second_received_email(worker)
    @worker = worker
    mail(to: "work@ri-plus.jp", subject: "#{@worker.name}さんが契約に同意しました。")
  end

  def second_send_email(worker)
    @worker = worker
    mail(to: worker.email, subject: '契約に同意いただきありがとうございます。')
  end
end
