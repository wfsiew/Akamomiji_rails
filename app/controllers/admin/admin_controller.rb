class Admin::AdminController < ApplicationController
  layout false
  
  # checks whether a user is authenticated before serving any request
  before_filter :authenticate
  
  # Display the admin page.
  # GET /admin/index
  def index
    respond_to do |fmt|
      fmt.html { render :layout => LAYOUT[:admin] }
    end
  end
end
