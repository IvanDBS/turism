class User < ApplicationRecord
  has_secure_password
  
  has_many :bookings, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :role, presence: true, inclusion: { in: %w[user admin] }
  
  before_validation :set_default_role, on: :create
  
  private
  
  def set_default_role
    self.role ||= 'user'
  end
end
