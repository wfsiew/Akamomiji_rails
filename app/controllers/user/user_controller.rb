class User::UserController < ApplicationController
  layout false
  
  before_filter :authenticate_user
  
  # GET /user/index
  def index
    respond_to do |fmt|
      fmt.html { render layout: LAYOUT[:user] }
    end
  end
  
  def authenticate_user
    unless authenticate
      return false
    end
    current_user == ApplicationHelper::UserRole::USER ? true : access_denied
  end
end
