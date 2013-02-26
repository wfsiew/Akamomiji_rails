require 'securerandom'

class Admin::JobPositionController < Admin::AdminController
  
  # GET /job
  # GET /job.json
  def index
    @data = JobPositionHelper.get_all
    
    respond_to do |fmt|
      fmt.html { render layout: LAYOUT[:list] }
      fmt.json { render json: @data }
    end
  end
  
  # GET /job/list
  # GET /job/list.json
  def list
    keyword = params[:keyword].blank? ? '' : params[:keyword]
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    sortcolumn = params[:sortcolumn].blank? ? JobPositionHelper::DEFAULT_SORT_COLUMN 
                                            : params[:sortcolumn]
    sortdir = params[:sortdir].blank? ? JobPositionHelper::DEFAULT_SORT_DIR : params[:sortdir]
    
    sort = ApplicationHelper::Sort.new(sortcolumn, sortdir)
    
    if keyword.blank?
      @data = JobPositionHelper.get_all(pgnum, pgsize, sort)
      
    else
      @data = JobPositionHelper.get_filter_by(keyword, pgnum, pgsize, sort)
    end
    
    respond_to do |fmt|
      fmt.html { render partial: 'list' }
      fmt.json { render json: @data }
    end
  end
  
  # GET /job/new
  # GET /job/new.json
  def new
    @job = JobPosition.new
    @form_id = 'add-form'
    
    respond_to do |fmt|
      fmt.html { render partial: 'form' }
      fmt.json { render json: @dept }
    end
  end
  
  # POST /job/create
  def create
    o = JobPosition.new(id: SecureRandom.uuid, name: params[:name])
    
    if o.save
      render json: {
        success: 1, 
        message: 'Job Position was successfully created.'
      }
      
    else
      render json: JobPositionHelper.get_errors(o.errors)
    end
  end
  
  # GET /job/edit/1
  # GET /job/edit/1.json
  def edit
    @job = JobPosition.find(params[:id])
    @form_id = 'edit-form'
    
    respond_to do |fmt|
      fmt.html { render partial: 'form' }
      fmt.json { render json: @job }
    end
  end
  
  # POST /job/update/1
  def update
    o = JobPosition.find(params[:id])
    
    if o.update_attributes(name: params[:name])
      render json: {
        success: 1, 
        message: 'Job Position was successfully updated.'
      }
        
    else
      render json: JobPositionHelper.get_errors(o.errors)
    end
  end
  
  # POST /job/delete
  def destroy
    keyword = params[:keyword].blank? ? '' : params[:keyword]
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    ids = params[:id]
    
    JobPosition.delete_all(id: ids)
    
    itemscount = JobPositionHelper.item_message(keyword, pgnum, pgsize)
    
    render json: {
      success: 1, 
      itemscount: itemscount, 
      message: "#{ids.size} Job Position(s) was successfully deleted."
    }
  end
  
  # GET /job/find/name
  def find_name
    keyword = "%#{params[:term]}%"
    n = JobPosition.select(:name).where('name like ?', keyword).order(:name).all
    render json: n.map { |o| { value: o[:name] } }
  end
end
