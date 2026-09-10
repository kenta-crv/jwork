class Client < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :jobs, dependent: :destroy
  has_many :situations, dependent: :destroy
  has_many :recruits, dependent: :nullify

  attr_accessor :skip_password_validation
  attr_accessor :post_title, :representative_name, :contact_name, :recruit_url,
                :visa, :message, :number, :house_support, :house_agents,
                :business, :genre, :salary, :work_time, :day_off, :work_contents

  validate :company_must_include_kaisha

  protected

  def password_required?
    return false if skip_password_validation
    super
  end

  private

  def company_must_include_kaisha
    unless company&.include?("会社")
      errors.add(:company, 'には「敬称」を含める必要があります')
    end
  end
end
