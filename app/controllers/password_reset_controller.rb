class PasswordResetController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  def new
  end
  def create
    @user=User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_reset_email
      render 'user_mailer/password_reset'
    else
      render 'new'
    end
  end
  def edit
  end
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update(user_info)
      login @user
      @user.update_attribute(:reset_digest, nil)
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  private
  def get_user
    @user=User.find_by(email: params[:email])
  end
  def valid_user
    unless @user && @user.authenticated?(:reset, params[:id]) && !@user.reset_available_checked? && @user.activated
      redirect_to root_url
    end
  end
  def user_info
    params.require(:user).permit(:password,:password_confirmation)
  end
end
