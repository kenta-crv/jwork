class  OfferMailer < ActionMailer::Base
    default from: "info@j-work.jp"
    def client_interview_received_email(offer, client)
      @offer = offer
      mail from: client.email
      mail to: "info@j-work.jp"
      mail(subject: '#{user.name}に面接打診を送信しました｜J Work') do |format|
        format.text
      end
    end
  
    def client_interview_admin_email(offer, client)
      @offer = offer
      mail from: "info@j-work.jp"
      mail to: "info@j-work.jp"
      mail(subject: '#{client.company}から#{user.name}に面接打診がありました。') do |format|
        format.text
      end
    end
  end
  