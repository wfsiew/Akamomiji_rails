class JobPosition < ActiveRecord::Base
  attr_accessible :id, :name
  
  self.table_name = 'job_position'
  
  validates_presence_of :name, :message => 'Name is required'
  validates_uniqueness_of :name, :message => "Position %{value} already exist"
end
