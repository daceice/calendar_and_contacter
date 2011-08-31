class UserPanelController < ApplicationController
  def index
  end
  
  def change_psw
    @user = @current_user
  end
  
  def change_psw_up
    status = false
    current_user = User.authenticate(@current_user.login_name, params[:plain_password])
    if @current_user && params[:new_password] && params[:new_password] != ''
      current_user.plain_password = params[:new_password]
      current_user.encrypt
      status = current_user.save
    end
    if status
      notify_success('change password success')
      redirect_to user_panel_index_url
    else
      notify_failure('change password failure')
      redirect_to user_panel_change_psw_url
    end
  end

end
