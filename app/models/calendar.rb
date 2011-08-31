class Calendar < ActiveRecord::Base
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  
  def content
    if self.note
      return self.note.gsub("\n",'<br>').gsub("\n\r",'<br>').gsub("\r\n",'<br>')
    else
      return ''
    end
  end
end
