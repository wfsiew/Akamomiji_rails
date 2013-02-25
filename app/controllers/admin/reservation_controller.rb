class Admin::ReservationController < Admin::AdminController
  def index
    
  end
  
  def list
    
  end
  
  def new
    
  end
  
  def create
    
  end
  
  def edit
    
  end
  
  def update
    
  end
  
  def destroy
    _reserve_date = params[:reserve_date]
    _reserve_time = params[:reserve_time]
    name = params[:name].blank? ? '' : params[:name]
    location = params[:location].blank? ? 0 : params[:location].to_i
    
    reserve_date = Date.strptime(_reserve_date, ApplicationHelper.date_fmt) if _reserve_date.present?
    reserve_time = Time.strptime(_reserve_time, ApplicationHelper.time_fmt) if _reserve_time.present?
    
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    ids = params[:id]
    
    Reservation.delete_all(:id => ids)
    
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
end
