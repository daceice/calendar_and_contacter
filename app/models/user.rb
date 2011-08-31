class User < ActiveRecord::Base
  
  attr_accessor :plain_password, :plain_password_confirmation
  validates_presence_of :login_name
  validates_uniqueness_of :login_name
  
  def show_name
    if self.name && self.name != ''
      return self.name
    else
      return login_name
    end
  end
  
  def encrypt
    if plain_password != nil && plain_password != ''
      cipher = OpenSSL::Cipher::Cipher.new('des3')
      cipher.encrypt
      cipher.key = 'E881EAAC9D26DF754A134C0DE09E31F4B8341939554D0EC0'
      cipher.iv = '00000000'
      self.password = cipher.update(plain_password)
      self.password << cipher.final
      self.password = Base64.encode64(password)
    end
  end
  
  # ==================================

  def self.authenticate( login_name, plain_password )
    return_value = nil
    user = User.find_by_login_name(login_name)
    puts user.inspect
    if user != nil && plain_password != nil && plain_password != ''#&& user.available == true 
      cipher = OpenSSL::Cipher::Cipher.new('des3')
      cipher.encrypt
      cipher.key = 'E881EAAC9D26DF754A134C0DE09E31F4B8341939554D0EC0'
      cipher.iv = '00000000'
      encrypt_password = cipher.update(plain_password)
      encrypt_password << cipher.final
      encrypt_password = Base64.encode64(encrypt_password)
      if encrypt_password == user.password
        return_value = user
      end
    end
    return return_value
  end
  
  def self.decrypt(encrypt_password)
    if encrypt_password != nil && encrypt_password != ''
      plain_password = Base64.decode64(encrypt_password)
      cipher = OpenSSL::Cipher::Cipher.new('des3')
      cipher.decrypt
      cipher.key = 'E881EAAC9D26DF754A134C0DE09E31F4B8341939554D0EC0'
      cipher.iv = '00000000'
      plain_password = cipher.update(plain_password)
      plain_password << cipher.final
    end
    return plain_password
  end
    
end
