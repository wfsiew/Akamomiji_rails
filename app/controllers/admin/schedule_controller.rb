class Admin::ScheduleController < Admin::AdminController
  
  # GET /sch/find/active/name
  def find_active_name
    keyword = "%#{params[:term]}%"
    q = Staff.where('status = 1 and name like ?', keyword)
    n = q.select('name, id, job_position_id').order(:name).all
    render json: n.map { |o| { value: o[:name], id: o[:id], job: get_job_position(o[:job_position_id]) } }
  end
  
  # GET /sch/week_days
  def week_days
    week = params[:week].blank? ? 0 : params[:week].to_i
    o = week_days_helper(week, DateTime.now.year)
    
    render json: o
  end
  
  def week_days_helper(week, year)
    o = []
    
    if week == 0
      return o
    end
    
    d = Date.commercial(DateTime.now.year, week)
    
    (1..7).each do |i|
      o.push(fmt_date(d))
      d = d.next
    end
    
    o
  end
  
  protected
  
  def get_job_position(id)
    s = ''
    begin
      o = JobPosition.find(id)
      s = o.name
    rescue Exception => e
      
    end
    
    s
  end
  
  helper_method :week_days_helper
end