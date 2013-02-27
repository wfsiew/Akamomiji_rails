require 'securerandom'

class Admin::KitchenSchController < Admin::ScheduleController
  
  # GET /sch/kitchen
  # GET /sch/kitchen.json
  def index
    @data = KitchenSchHelper.get_all
    @location_list = ApplicationHelper::Location.data
    @category_list = KitchenSch.category_data
    @week_list = ApplicationHelper.week_data
    
    respond_to do |fmt|
      fmt.html { render layout: LAYOUT[:list] }
      fmt.json { render json: @data }
    end
  end
  
  # GET /sch/kitchen/list
  # GET /sch/kitchen/list.json
  def list
    category = params[:category].blank? ? 0 : params[:category].to_i
    name = params[:name].blank? ? '' : params[:name]
    location = params[:location].blank? ? 0 : params[:location].to_i
    week = params[:week].blank? ? 0 : params[:week].to_i
    
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    sortcolumn = params[:sortcolumn].blank? ? KitchenSchHelper::DEFAULT_SORT_COLUMN 
                                            : params[:sortcolumn]
    sortdir = params[:sortdir].blank? ? KitchenSchHelper::DEFAULT_SORT_DIR : params[:sortdir]
    
    sort = ApplicationHelper::Sort.new(sortcolumn, sortdir)
    
    filters = {
      category: category,
      name: name,
      location: location,
      week: week
    }
    
    if category == 0 && name.blank? && location == 0 && week == 0
      @data = KitchenSchHelper.get_all(pgnum, pgsize, sort)
      
    else
      @data = KitchenSchHelper.get_filter_by(filters, pgnum, pgsize, sort)
    end
    
    @location_list = ApplicationHelper::Location.data
    @category_list = KitchenSch.category_data
    
    respond_to do |fmt|
      fmt.html { render partial: 'list' }
      fmt.json { render json: @data }
    end
  end
  
  # GET /sch/kitchen/new
  # GET /sch/kitchen/new.json
  def new
    @sch = KitchenSch.new
    @form_id = 'add-form'
    @location_list = ApplicationHelper::Location.data
    @category_list = KitchenSch.category_data
    @week_list = ApplicationHelper.week_data
    @shift_list = ApplicationHelper.shift_data
    @staff_list = Staff.where(status: 1).order(:name).all
    
    respond_to do |fmt|
      fmt.html { render partial: 'form' }
      fmt.json { render json: @sch }
    end
  end
  
  # POST /sch/kitchen/create
  def create
    o = KitchenSch.new(id: SecureRandom.uuid, category: params[:category], staff_id: params[:staff_id],
                       location: params[:location], week: params[:week], year: DateTime.now.year, 
                       mon: params[:mon], tue: params[:tue], wed: params[:wed], thur: params[:thur], 
                       fri: params[:fri], sat: params[:sat], sun: params[:sun])
                       
    if o.save
      render json: {
        success: 1,
        message: 'Kitchen Schedule was successfully created.'
      }
      
    else
      render json: KitchenSchHelper.get_errors(o.errors)
    end
  end
  
  # GET /sch/kitchen/edit/1
  # GET /sch/kitchen/edit/1.json
  def edit
    @sch = KitchenSch.find(params[:id])
    @form_id = 'edit-form'
    @location_list = ApplicationHelper::Location.data
    @category_list = KitchenSch.category_data
    @week_list = ApplicationHelper.week_data
    @shift_list = ApplicationHelper.shift_data
    @staff_list = Staff.where(status: 1).order(:name).all
    
    respond_to do |fmt|
      fmt.html { render partial: 'form' }
      fmt.json { render json: @sch }
    end
  end
  
  # POST /sch/kitchen/update/1
  def update
    o = KitchenSch.find(params[:id])
    
    if o.update_attributes(category: params[:category], staff_id: params[:staff_id],
      location: params[:location], week: params[:week], year: DateTime.now.year, 
      mon: params[:mon], tue: params[:tue], wed: params[:wed], thur: params[:thur], 
      fri: params[:fri], sat: params[:sat], sun: params[:sun])
      render json: {
        success: 1,
        message: 'Kitchen Schedule was successfully updated.'
      }
      
    else
      render json: KitchenSchHelper.get_errors(o.errors)
    end
  end
  
  # POST /sch/kitchen/update/location/1
  def update_location
    o = KitchenSch.find(params[:id])
    location = o.location
    
    if o.update_attributes(location: params[:location])
      render json: {
        success: 1,
        location: params[:location]
      }
      
    else
      render json: {
        error: 1,
        location: location.to_s
      }
    end
  end
  
  # POST /sch/kitchen/delete
  def destroy
    category = params[:category].blank? ? 0 : params[:category].to_i
    name = params[:name].blank? ? '' : params[:name]
    location = params[:location].blank? ? 0 : params[:location].to_i
    week = params[:week].blank? ? 0 : params[:week].to_i
    
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    ids = params[:id]
    
    KitchenSch.delete_all(id: ids)
    
    filters = {
      category: category,
      name: name,
      location: location,
      week: week
    }
    
    if category == 0 && name.blank? && location == 0 && week == 0
      itemscount = KitchenSchHelper.item_message(nil, pgnum, pgsize)
      
    else
      itemscount = KitchenSchHelper.item_message(filters, pgnum, pgsize)
    end
    
    render json: {
      success: 1,
      itemscount: itemscount,
      message: "#{ids.size} Kitchen Schedule(s) was successfully deleted."
    }
  end
  
  # GET /sch/kitchen/find/name
  def find_name
    keyword = "%#{params[:term]}%"
    q = KitchenSch.joins('inner join staff s on kitchen_sch.staff_id = s.id')
    q = q.where('s.name like ?', keyword)
    n = q.select('s.name').order('s.name').all
    render json: n.map { |o| { value: o[:name] } }
  end
end
