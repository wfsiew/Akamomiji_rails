class Staff < ActiveRecord::Base
  attr_accessible :contact_no, :id, :name, :remarks, :status
  
  self.table_name = 'staff'
  
  validates_presence_of :contact_no, :message => 'Contact number is required'
  validates_presence_of :name, :message => 'Name is required'
  validates_presence_of :status, :message => 'Status is required'
end