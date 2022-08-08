module SessionsHelper
  def logged_in?
    !current_user.nil?
  end
  def login(user)
    session[:user_id]=user.id
  end
  def current_user
    if (user_id = session[:user_id])
      @current_user||=User.find_by(id: user_id)
    elsif(user_id= cookies.signed[user_id])
      user= User.find_by(id: user_id)
      if user&.authenticated?(cookies[:remember_token])
        login user
        @current_user=user
      end
    end
  end

  def logout
    forget current_user
    @current_user=nil
    session[:user_id]=nil
  end
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id]=user.id
    cookies.permanent[:remember_token]=user.remember_token
  end
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  def store_location
    session[:url_stored]=request.original_url if request.get?
  end
end
