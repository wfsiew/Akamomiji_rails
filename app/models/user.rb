require 'digest'

class User < ActiveRecord::Base
  attr_accessible :id, :pwd, :role, :pwd_confirmation
  attr_accessor :pwd
  
  self.table_name = 'user'
  
  validates :pwd, confirmation: { message: "Password doesn't match confirmation" },
                  length: { within: 4..20, 
                            message: "Minimum is %{count} characters" },
                  presence: { message: "Password is required" },
                  :if => :password_required?
                  
  before_save :encrypt_new_password
  
  UNCHANGED_PASSWORD = '********'
  
  def self.authenticate(role, password)
    user = find_by_role(role)
    if user && user.authenticated?(password)
      return user
    end
  end
  
  def authenticated?(password)
    self.password == encrypt(password)
  end
  
  def role_str
    ApplicationHelper::UserRole.str(self.role)
  end
  
  protected
  
  def encrypt_new_password
    return if pwd.blank? || pwd == UNCHANGED_PASSWORD
    self.password = encrypt(pwd)
  end
  
  def password_required?
    if pwd == UNCHANGED_PASSWORD
      return false
    end
    self.password.blank? || pwd.present?
  end
  
  def encrypt(string)
    Digest::SHA1.hexdigest(string)
  end
end
