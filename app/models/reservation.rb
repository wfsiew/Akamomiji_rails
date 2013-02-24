class Reservation < ActiveRecord::Base
  attr_accessible :id, :location, :name, :pax, :phone_no, :remarks, :reserve_date, :reserve_time, :table
end
