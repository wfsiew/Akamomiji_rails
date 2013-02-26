class ServiceSch < ActiveRecord::Base
  attr_accessible :category, :fri, :id, :location, :mon, :sat, :staff_id, :sun, :thur, :tue, :wed, :week, :year
  
  self.table_name = 'service_sch'
  
  belongs_to :staff
  
  validates_presence_of :category, message: 'Category is required'
  validates_presence_of :location, message: 'Location is required'
  validates_presence_of :staff_id, message: 'Staff ID is required'
  validates_presence_of :week, message: 'Week is required'
  validates_presence_of :year, message: 'Year is required'
  
  def self.category_data
    [['Service', 1], ['Part-Timer', 2]]
  end
  
  def category_str
    case self.category
    when 1
      'Service'
      
    when 2
      'Part-Timer'
      
    else
      ''
    end
  end
end
