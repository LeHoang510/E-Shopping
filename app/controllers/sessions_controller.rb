class SessionsController < ApplicationController
  def new
  end
  def create
    @user=User.find_by(email: params[:session][:email])
    if @user&.authenticate(params[:session][:password])
      if params[:session][:remember_me] == '1'
        remember @user
      else
        forget @user
      end
      login @user
      redirect_to user_path(@user)
    end
  end
  def destroy
    logout
    redirect_to root_path
  end
end
