class Offer < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :worker, optional: true
  belongs_to :client, optional: true
  belongs_to :customer, optional: true

  validates :message, length: { minimum: 50, message: 'は50文字以上で入力してください' }

  # 条件付きバリデーション
  validates :client, presence: true, if: :client_required?
  validates :customer, presence: true, if: :customer_required?
  validates :user, presence: true, if: :user_required?
  validates :worker, presence: true, if: :worker_required?
  
  #after_create :notify_recipient

  private

  #def notify_recipient
    # 通知ロジックを追加 (例: メール送信、プッシュ通知)
   # OfferMailer.with(offer: self).new_offer_email.deliver_later
  #end

  private

  def client_required?
    client.present?
  end

  def customer_required?
    customer.present?
  end

  def user_required?
    user.present?
  end

  def worker_required?
    worker.present?
  end
end
