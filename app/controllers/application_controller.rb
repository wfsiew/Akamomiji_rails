class ApplicationController < ActionController::Base
  protect_from_forgery
  
  LAYOUT = {
    admin: 'admin',
    list: 'list',
    supervisor: 'supervisor',
    user: 'user'
  }
  
  def new
    @role_list = ApplicationHelper::UserRole.data
    
    respond_to do |fmt|
      fmt.html
    end
  end
  
  # Authenticates a user.
  def create
    user = User.authenticate(params[:role], params[:password])
    if user.present?
      session[:user_role] = user.role
      if user.role == ApplicationHelper::UserRole::ADMIN ||
        user.role == ApplicationHelper::UserRole::MANAGEMENT
        redirect_to admin_index_path and return
        
      elsif user.role == ApplicationHelper::UserRole::SUPERVISOR
        redirect_to supervisor_index_path and return
        
      else
        redirect_to user_index_path and return
      end
      
    else
      flash.now[:alert] = 'Incorrect password'
    end
    
    @role_list = ApplicationHelper::UserRole.data
    
    render action: 'new'
  end
  
  def destroy
    reset_session
    redirect_to login_path
  end
  
  protected
  
  def current_user
    return unless session[:user_role]
    @current_user ||= session[:user_role]
  end
  
  def authenticate
    logged_in? ? true : access_denied
  end
  
  def logged_in?
    current_user.present?
  end
  
  def access_denied
    redirect_to login_path, notice: 'Please log in to continue' and return false
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
  
  # Formats a time into hh:mm 24 hour format .
  # Helper method.
  def fmt_miltime(t)
    if t.present?
      ApplicationHelper.localtime(t).strftime(ApplicationHelper.time_fmt)
    end
  end
  
  def get_user_role
    session[:user_role]
  end
  
  helper_method :current_user
  helper_method :logged_in
  helper_method :fmt_date
  helper_method :fmt_time
  helper_method :fmt_miltime
end
