class Staff < ActiveRecord::Base
  attr_accessible :contact_no, :id, :name, :job_position_id, :remarks, :status
  
  self.table_name = 'staff'
  
  has_many :kitchen_sch, :foreign_key => 'staff_id'
  has_many :service_sch, :foreign_key => 'staff_id'
  belongs_to :job_position
  
  validates_presence_of :contact_no, message: 'Contact number is required'
  validates_presence_of :name, message: 'Name is required'
  validates_presence_of :status, message: 'Status is required'
  validates_presence_of :job_position_id, message: 'Job position is required'
  
  def status_str
    ApplicationHelper::StaffStatus.str(self.status)
  end
end
