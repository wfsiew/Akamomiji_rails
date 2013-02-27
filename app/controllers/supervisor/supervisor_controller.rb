class Supervisor::SupervisorController < ApplicationController
  layout false
  
  before_filter :authenticate_supervisor
  
  # GET /supervisor/index
  def index
    respond_to do |fmt|
      fmt.html { render layout: LAYOUT[:supervisor] }
    end
  end
  
  def authenticate_supervisor
    unless authenticate
      return false
    end
    current_user == ApplicationHelper::UserRole::SUPERVISOR ? true : access_denied
  end
end
