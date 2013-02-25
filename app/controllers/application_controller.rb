class ApplicationController < ActionController::Base
  protect_from_forgery
  
  LAYOUT = {
    admin: 'admin',
    user: 'user'
  }
  
  # Authenticates a user.
  def create
    
  end
  
  # Logs out a user.
  def destroy
    reset_session
    redirect_to login_path
  end
  
  protected
  
  # Returs the current user's user_id.
  def current_user
    return unless session[:user_id]
    @current_user ||= session[:user_id]
  end
  
  # Checks whether a user is authenticated.
  def authenticate
    logged_in? ? true : access_denied
  end
  
  # Checks whether a user is logged in.
  def logged_in?
    current_user.present?
  end
  
  # Prevents a user from accessing the system without logging in.
  def access_denied
    redirect_to login_path, :notice => 'Please log in to continue' and return false
  end
  
  # Formats a date into dd-mm-yyyy .
  # Helper method.
  def fmt_date(dt)
    if dt.present?
      dt.strftime(ApplicationHelper.date_fmt)
    end
  end
  
  # Formats a time into hh:mm:ss AM/PM .
  # Helper method.
  def fmt_time(t)
    if t.present?
      ApplicationHelper.localtime(t).strftime('%l:%M %p')
    end
  end
  
  # Returns the user_id.
  def get_user_id
    session[:user_id]
  end
  
  helper_method :current_user
  helper_method :logged_in
  helper_method :fmt_date
  helper_method :fmt_time
end
