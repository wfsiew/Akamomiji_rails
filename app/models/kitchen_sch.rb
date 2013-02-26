class KitchenSch < ActiveRecord::Base
  attr_accessible :category, :fri, :id, :location, :mon, :sat, :staff_id, :sun, :thur, :tue, :wed, :week, :year
  
  self.table_name = 'kitchen_sch'
  
  belongs_to :staff
  
  validates_presence_of :category, message: 'Category is required'
  validates_presence_of :location, message: 'Location is required'
  validates_presence_of :staff_id, message: 'Staff ID is required'
  validates_presence_of :week, message: 'Week is required'
  validates_presence_of :year, message: 'Year is required'
  
  def self.category_data
    [['Sushi Bar', 1], ['Kitchen', 2], ['Part-Timer', 3]]
  end
  
  def category_str
    case self.category
    when 1
      'Sushi Bar'
      
    when 2
      'Kitchen'
      
    when 3
      'Part-Timer'
      
    else
      ''
    end
  end
end
