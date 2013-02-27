class Admin::UserController < Admin::AdminController
  
  # GET /user
  # GET /user.json
  def index
    @data = UserHelper.get_all
    
    respond_to do |fmt|
      fmt.html { render layout: LAYOUT[:list] }
      fmt.json { render json: @data }
    end
  end
  
  # GET /user/list
  # GET /user/list.json
  def list
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    sortcolumn = params[:sortcolumn].blank? ? UserHelper::DEFAULT_SORT_COLUMN : params[:sortcolumn]
    sortdir = params[:sortdir].blank? ? UserHelper::DEFAULT_SORT_DIR : params[:sortdir]
    
    sort = ApplicationHelper::Sort.new(sortcolumn, sortdir)
    
    @data = UserHelper.get_all(pgnum, pgsize, sort)
    
    respond_to do |fmt|
      fmt.html { render partial: 'list' }
      fmt.json { render json: @data }
    end
  end
  
  # GET /user/edit/1
  # GET /user/edit/1.json
  def edit
    @user = User.find(params[:id])
    @form_id = 'edit-form'
    
    respond_to do |fmt|
      fmt.html { render partial: 'form' }
      fmt.json { render json: @user }
    end
  end
  
  # POST /user/update
  def update
    o = User.find(params[:id])
    pwd = params[:pwd]
    
    if o.update_attributes(pwd: params[:pwd], pwd_confirmation: params[:pwdconfirm])
      render json: {
        success: 1, 
        message: 'User was successfully updated.'
      }
        
    else
      render json: UserHelper.get_errors(o.errors)
    end
  end
end
