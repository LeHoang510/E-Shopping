# Preview all emails at http://localhost:3000/rails/mailers/account_activation_mailer
class AccountActivationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/account_activation_mailer/password_reset
  def password_reset
    AccountActivationMailer.password_reset
  end

end
