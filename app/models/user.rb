class User < ApplicationRecord
  attr_accessor :remember_token

  before_save :email_downcase

  validates :email, presence: true, length: {maximum: 100},uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: {maximum: 50}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true
  validates :coin, :numericality => { :greater_than_or_equal_to => 0 }

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    def token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token=User.token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  private
    def email_downcase
      self.email.downcase!
    end
end
