class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :worker, dependent: :destroy
  after_create :create_worker
  has_many :offers

  private

  def create_worker
    Worker.create(user: self)
  end
end
