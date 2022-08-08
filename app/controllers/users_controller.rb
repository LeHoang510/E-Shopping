class UsersController < ApplicationController
  before_action :logged_in_as_user, only: [:edit,:update]
  before_action :correct_user?, only:[:edit,:update]
  def new
    @user=User.new
  end
  def create
    @user=User.new(user_params)
    @user.coin=0.0
    if @user.save
      login @user
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end
  def show
    @user=User.find(params[:id])
  end
  def edit
    @user=User.find(params[:id])
  end
  def update
    @user=User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  def correct_user?
    user=User.find(params[:id])
    unless user && user==current_user
      redirect_to root_url
    end
  end
end
