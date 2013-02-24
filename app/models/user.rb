class User < ActiveRecord::Base
  attr_accessible :id, :password, :role, :type
end
