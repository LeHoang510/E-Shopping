class User < ApplicationRecord
  before_save :email_downcase

  validates :email, presence: true, length: {maximum: 100},uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: {maximum: 50}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}
  validates :coin, :numericality => { :greater_than_or_equal_to => 0 }
  private
    def email_downcase
      self.email.downcase!
    end
end
