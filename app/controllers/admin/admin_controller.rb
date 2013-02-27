class Admin::AdminController < ApplicationController
  layout false
  
  before_filter :authenticate
  
  # GET /admin/index
  def index
    respond_to do |fmt|
      fmt.html { render layout: LAYOUT[:admin] }
    end
  end
end
