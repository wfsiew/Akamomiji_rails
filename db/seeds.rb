# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'securerandom'

def init
  create_user
end

private

def create_user
  (1..4).each do |i|
    o = User.create(id: SecureRandom.uuid, pwd: 'user123', pwd_confirmation: 'user123', 
                    role: i)
  end
end

init
