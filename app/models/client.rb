class Client < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :jobs, dependent: :destroy
  has_many :situations, dependent: :destroy
  has_many :recruits, dependent: :nullify
  has_many :contracts, dependent: :nullify

  attr_accessor :skip_password_validation
  attr_accessor :post_title, :representative_name, :contact_name, :recruit_url,
                :visa, :message, :number, :house_support, :house_agents,
                :business, :genre, :salary, :work_time, :day_off, :work_contents

  validate :company_must_include_kaisha

  def self.register_from_job_inquiry!(contract)
    email = contract.email.to_s.strip
    client = where("LOWER(email) = ?", email.downcase).first || new(email: email)
    client.skip_password_validation = true
    client.company = contract.company
    client.person = contract.name
    client.tel = contract.tel
    client.address = contract.address
    client.url = contract.url if contract.url.present?

    extra = [
      contract.message.presence,
      ("求人URL: #{contract.url}" if contract.url.present?)
    ].compact.join("\n")
    if extra.present? && client.remarks.to_s.exclude?(extra)
      client.remarks = [client.remarks.presence, extra].compact.join("\n")
    end
    client.save!

    contract.update!(client_id: client.id)
    client
  end

  def send_portal_setup_instructions!
    raw, hashed = Devise.token_generator.generate(self.class, :reset_password_token)
    update_columns(
      reset_password_token: hashed,
      reset_password_sent_at: Time.current.utc
    )
    ClientMailer.password_setup_email(self, raw).deliver_now
  end

  protected

  def password_required?
    return false if skip_password_validation
    super
  end

  private

  def company_must_include_kaisha
    unless company&.include?("会社") || company&.include?("組合")
      errors.add(:company, 'には「敬称」を含める必要があります')
    end
  end
end
