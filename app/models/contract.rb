class Contract < ApplicationRecord
  # LPフォームから送られる送信元パス（カラム未追加のためメモリ保持のみ）
  attr_accessor :origin

  validate :company_must_include_kaisha

  private

  def company_must_include_kaisha
    return if company.blank?

    unless company.include?("会社") || company.include?("組合")
      errors.add(:company, 'には「敬称」を含める必要があります')
    end
  end
end


