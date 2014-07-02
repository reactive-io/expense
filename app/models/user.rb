class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :expense_items

  before_create :generate_api_token!

  private

  def generate_api_token!
    self.api_token = SecureRandom.hex(32)
  end
end
