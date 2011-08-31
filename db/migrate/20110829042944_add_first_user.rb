require 'base64'
class AddFirstUser < ActiveRecord::Migration
  
  def self.up
    if User.count == 0
      user = User.new
      user.login_name = 'manager'
      user.plain_password = '123456'
      user.encrypt
      user.save
    end
  end

  def self.down
  end
end
