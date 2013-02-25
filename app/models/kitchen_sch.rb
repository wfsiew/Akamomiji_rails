class KitchenSch < ActiveRecord::Base
  attr_accessible :category, :fri, :id, :location, :mon, :position, :sat, :staff_id, :sun, :thur, :tue, :wed, :week, :year
  
  self.table_name = 'kitchen_sch'
  
  belongs_to :staff, :foreign_key => 'staff_id'
  
  validates_presence_of :category, message: 'Category is required'
  validates_presence_of :location, message: 'Location is required'
  validates_presence_of :staff_id, message: 'Staff ID is required'
  validates_presence_of :week, message: 'Week is required'
  validates_presence_of :year, message: 'Year is required'
end
