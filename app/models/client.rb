class Client < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :offers, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :company, format: { without: /\p{Greek}|\p{Cyrillic}/, message: "に不正な文字（ギリシャ文字やキリル文字など）が含まれています" }
end
