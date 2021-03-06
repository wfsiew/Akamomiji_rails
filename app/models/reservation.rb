class Reservation < ActiveRecord::Base
  attr_accessible :id, :location, :name, :pax, :phone_no, :remarks, :reserve_date, :reserve_time, 
                  :status, :table
  
  self.table_name = 'reservation'
  
  validates_presence_of :location, message: 'Location is required'
  validates_presence_of :name, message: 'Name is required'
  validates_presence_of :pax, message: 'Pax is required'
  validates_presence_of :phone_no, message: 'Phone no. is required'
  validates_presence_of :reserve_date, message: 'Reserve date is required'
  validates_presence_of :reserve_time, message: 'Reserve time is required'
  validates_presence_of :status, message: 'Status is required'
  validates_presence_of :table, message: 'Table is required'
  
  def location_str
    ApplicationHelper::Location.str(self.location)
  end
  
  def status_str
    ApplicationHelper::ReservationStatus.str(self.status)
  end
end
