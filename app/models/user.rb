class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :email_downcase
  before_create :create_activation_digest

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
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def authenticated?(attr, token)
    digest=self.send("#{attr}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def create_reset_digest
    self.reset_token=User.token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end
  def reset_available_checked?
    reset_sent_at < 2.hour.ago
  end
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  def send_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  private
    def email_downcase
      self.email.downcase!
    end
    def create_activation_digest
      self.activation_token=User.token
      self.activation_digest=User.digest(activation_token)
    end
end
