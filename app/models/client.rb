class Client < ApplicationRecord
  has_many :jobs, dependent: :destroy
  has_many :situations, dependent: :destroy

  validate :company_must_include_kaisha

  private

  def company_must_include_kaisha
    unless company&.include?("会社")
      errors.add(:company, 'には「敬称」を含める必要があります')
    end
  end
end
