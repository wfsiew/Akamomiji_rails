class KitchenSch < ActiveRecord::Base
  attr_accessible :category, :fri, :id, :location, :mon, :name, :position, :sat, :sun, :thur, :tue, :wed, :week, :year
  
  self.table_name = 'kitchen_sch'
  
  validates_presence_of :category, :message => 'Category is required'
  validates_presence_of :location, :message => 'Location is required'
  validates_presence_of :name, :message => 'Name is required'
  validates_presence_of :week, :message => 'Week is required'
  validates_presence_of :year, :message => 'Year is required'
end
