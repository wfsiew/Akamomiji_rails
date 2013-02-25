class User < ActiveRecord::Base
  attr_accessible :id, :password, :role, :type
  
  self.table_name = 'user'
end
