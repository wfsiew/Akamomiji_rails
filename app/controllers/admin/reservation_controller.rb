require 'securerandom'

class Admin::ReservationController < Admin::AdminController
  
  # GET /resv
  # GET /resv.json
  def index
    @data = ReservationHelper.get_all
    @location_list = ApplicationHelper::Location.data
    @status_list = ApplicationHelper::ReservationStatus.data
    
    respond_to do |fmt|
      fmt.html { render layout: LAYOUT[:list] }
      fmt.json { render json: @data }
    end
  end
  
  # GET /resv/list
  # GET /resv/list.json
  def list
    _reserve_date = params[:reserve_date]
    _reserve_time = params[:reserve_time]
    name = params[:name].blank? ? '' : params[:name]
    location = params[:location].blank? ? 0 : params[:location].to_i
    
    reserve_date = Date.strptime(_reserve_date, ApplicationHelper.date_fmt) if _reserve_date.present?
    reserve_time = Time.strptime(_reserve_time, ApplicationHelper.time_fmt) if _reserve_time.present?
    
    if reserve_time.present?
      reserve_time = ApplicationHelper.to_localtime(DateTime.now.to_date, reserve_time)
    end
    
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    sortcolumn = params[:sortcolumn].blank? ? ReservationHelper::DEFAULT_SORT_COLUMN 
                                            : params[:sortcolumn]
    sortdir = params[:sortdir].blank? ? ReservationHelper::DEFAULT_SORT_DIR : params[:sortdir]
    
    sort = ApplicationHelper::Sort.new(sortcolumn, sortdir)
    
    filters = {
      reserve_date: reserve_date,
      reserve_time: reserve_time,
      name: name,
      location: location
    }
    
    if reserve_date.blank? && reserve_time.blank? && name.blank? && location == 0
      @data = ReservationHelper.get_all(pgnum, pgsize, sort)
      
    else
      @data = ReservationHelper.get_filter_by(filters, pgnum, pgsize, sort)
    end
    
    @location_list = ApplicationHelper::Location.data
    @status_list = ApplicationHelper::ReservationStatus.data
    
    respond_to do |fmt|
      fmt.html { render partial: 'list' }
      fmt.json { render json: @data }
    end
  end
  
  # GET /resv/new
  # GET /resv/new.json
  def new
    @reservation = Reservation.new
    @form_id = 'add-form'
    @location_list = ApplicationHelper::Location.data
    @status_list = ApplicationHelper::ReservationStatus.data
    
    respond_to do |fmt|
      fmt.html { render partial: 'form' }
      fmt.json { render json: @reservation }
    end
  end
  
  # POST /resv/create
  def create
    _reserve_date = params[:reserve_date]
    _reserve_time = params[:reserve_time]
    
    reserve_date = Date.strptime(_reserve_date, ApplicationHelper.date_fmt) if _reserve_date.present?
    reserve_time = Time.strptime(_reserve_time, ApplicationHelper.gen_time_fmt) if _reserve_time.present?
    
    if reserve_date.present? && reserve_time.present?
      reserve_time = ApplicationHelper.to_localtime(reserve_date, reserve_time)
    end
    
    o = Reservation.new(id: SecureRandom.uuid, reserve_date: reserve_date, reserve_time: reserve_time,
                        name: params[:name], pax: params[:pax], table: params[:table],
                        phone_no: params[:phone_no], remarks: params[:remarks], location: params[:location], 
                        status: params[:status])
                        
    if o.save
      render json: {
        success: 1,
        message: 'Reservation was successfully created.'
      }
      
    else
      render json: ReservationHelper.get_errors(o.errors)
    end
  end
  
  # GET /resv/edit/1
  # GET /resv/edit/1.json
  def edit
    @reservation = Reservation.find(params[:id])
    @form_id = 'edit-form'
    @location_list = ApplicationHelper::Location.data
    @status_list = ApplicationHelper::ReservationStatus.data
    
    respond_to do |fmt|
      fmt.html { render partial: 'form' }
      fmt.json { render json: @reservation }
    end
  end
  
  # POST /resv/update/1
  def update
    o = Reservation.find(params[:id])
    
    _reserve_date = params[:reserve_date]
    _reserve_time = params[:reserve_time]
    
    reserve_date = Date.strptime(_reserve_date, ApplicationHelper.date_fmt) if _reserve_date.present?
    reserve_time = Time.strptime(_reserve_time, ApplicationHelper.gen_time_fmt) if _reserve_time.present?
    
    if reserve_date.present? && reserve_time.present?
      reserve_time = ApplicationHelper.to_localtime(reserve_date, reserve_time)
    end
    
    if o.update_attributes(reserve_date: reserve_date, reserve_time: reserve_time,
      name: params[:name], pax: params[:pax], table: params[:table],
      phone_no: params[:phone_no], remarks: params[:remarks], location: params[:location], 
      status: params[:status])
      render json: {
        success: 1,
        message: 'Reservation was successfully updated.'
      }
      
    else
      render json: ReservationHelper.get_errors(o.errors)
    end
  end
  
  # POST /resv/update/location/1
  def update_location
    o = Reservation.find(params[:id])
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
  
  # POST /resv/update/status/1
  def update_status
    o = Reservation.find(params[:id])
    status = o.status
    
    if o.update_attributes(status: params[:status])
      render json: {
        success: 1,
        status: params[:status]
      }
      
    else
      render json: {
        error: 1,
        status: status.to_s
      }
    end
  end
  
  # POST /resv/delete
  def destroy
    _reserve_date = params[:reserve_date]
    _reserve_time = params[:reserve_time]
    name = params[:name].blank? ? '' : params[:name]
    location = params[:location].blank? ? 0 : params[:location].to_i
    
    reserve_date = Date.strptime(_reserve_date, ApplicationHelper.date_fmt) if _reserve_date.present?
    reserve_time = Time.strptime(_reserve_time, ApplicationHelper.time_fmt) if _reserve_time.present?
    
    if reserve_time.present?
      reserve_time = ApplicationHelper.to_localtime(DateTime.now.to_date, reserve_time)
    end
    
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    ids = params[:id]
    
    Reservation.delete_all(id: ids)
    
    filters = {
      reserve_date: reserve_date,
      reserve_time: reserve_time,
      name: name,
      location: location
    }
    
    if reserve_date.blank? && reserve_time.blank? && name.blank? && location == 0
      itemscount = ReservationHelper.item_message(nil, pgnum, pgsize)
      
    else
      itemscount = ReservationHelper.item_message(filters, pgnum, pgsize)
    end
    
    render json: {
      success: 1,
      itemscount: itemscount,
      message: "#{ids.size} reservation(s) was successfully deleted."
    }
  end
  
  # GET /resv/find/name
  def find_name
    keyword = "%#{params[:term]}%"
    n = Reservation.select(:name).where('name like ?', keyword).order(:name).all
    render json: n.map { |o| { value: o[:name] } }
  end
end
