class AccountActivationsController < ApplicationController
  def edit
    @user=User.find_by(email: params[:email])
    if @user && !@user.activated && @user.authenticated?(:activation, params[:id])
      @user.activate
      login @user
      redirect_to user_path(@user)
    else
      redirect_to root_url
    end
  end
end
