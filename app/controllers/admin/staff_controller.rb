require 'securerandom'

class Admin::StaffController < Admin::AdminController
  
  # GET /staff
  # GET /staff.json
  def index
    @data = StaffHelper.get_all
    @status_list = ApplicationHelper::StaffStatus.data
    
    respond_to do |fmt|
      fmt.html { render layout: LAYOUT[:list] }
      fmt.json { render json: @data }
    end
  end
  
  # GET /staff/list
  # GET /staff/list.json
  def list
    name = params[:name].blank? ? '' : params[:name]
    status = params[:status].blank? ? 0 : params[:status].to_i
    
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    sortcolumn = params[:sortcolumn].blank? ? StaffHelper::DEFAULT_SORT_COLUMN 
                                            : params[:sortcolumn]
    sortdir = params[:sortdir].blank? ? StaffHelper::DEFAULT_SORT_DIR : params[:sortdir]
    
    sort = ApplicationHelper::Sort.new(sortcolumn, sortdir)
    
    filters = {
      name: name,
      status: status
    }
    
    if name.blank? && status == 0
      @data = StaffHelper.get_all(pgnum, pgsize, sort)
      
    else
      @data = StaffHelper.get_filter_by(filters, pgnum, pgsize, sort)
    end
    
    respond_to do |fmt|
      fmt.html { render partial: 'list' }
      fmt.json { render json: @data }
    end
  end
  
  # GET /staff/new
  # GET /staff/new.json
  def new
    @staff = Staff.new
    @form_id = 'add-form'
    @status_list = ApplicationHelper::StaffStatus.data
    
    respond_to do |fmt|
      fmt.html { render partial: 'form' }
      fmt.json { render json: @staff }
    end
  end
  
  # POST /staff/create
  def create
    o = Staff.new(id: SecureRandom.uuid, name: params[:name], contact_no: params[:contact_no],
                  status: params[:status], remarks: params[:remarks])
                  
    if o.save
      render json: {
        success: 1,
        message: 'Staff was successfully created.'
      }
      
    else
      render json: StaffHelper.get_errors(o.errors)
    end
  end
  
  # GET /staff/edit/1
  # GET /staff/edit/1.json
  def edit
    @staff = Staff.find(params[:id])
    @form_id = 'edit-form'
    @status_list = ApplicationHelper::StaffStatus.data
    
    respond_to do |fmt|
      fmt.html { render partial: 'form' }
      fmt.json { render json: @staff }
    end
  end
  
  # POST /staff/update/1
  def update
    o = Staff.find(params[:id])
    
    if o.update_attributes(name: params[:name], contact_no: params[:contact_no],
      status: params[:status], remarks: params[:remarks])
      render json: {
        success: 1,
        message: 'Staff was successfully updated.'
      }
      
    else
      render json: StaffHelper.get_errors(o.errors)
    end
  end
  
  # POST /staff/delete
  def destroy
    name = params[:name].blank? ? '' : params[:name]
    status = params[:status].blank? ? 0 : params[:status].to_i
    
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    ids = params[:id]
    
    Staff.delete_all(id: ids)
    
    filters = {
      name: name,
      status: status
    }
    
    if name.blank? && status == 0
      itemscount = StatusHelper.item_message(nil, pgnum, pgsize)
      
    else
      itemscount = StatusHelper.item_message(filters, pgnum, pgsize)
    end
    
    render json: {
      success: 1,
      itemscount: itemscount,
      message: "#{ids.size} staff(s) was successfully deleted."
    }
  end
end
