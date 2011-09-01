class SessionController < ApplicationController
  
  before_filter :require_user_login, :only => []
  
  def new
    user = fetch_current_user
    if user != nil
      redirect_to user_panel_index_url
    end
  end
  
  def create
    #puts params[:plain_password]
    @current_user = User.authenticate(params[:login_name], params[:plain_password])
    if @current_user != nil
      session[:user_id] = @current_user.id
      notify_success('')
      respond_to do |format|
        format.html { return_to_return_to(user_panel_index_url, params[:return_url]) }
      end
    else
      respond_to do |format|
        notify_failure('登陆失败，用户名或密码错误。')
        format.html { 
          render :action => 'new', :return_url => params[:return_url], :login_name => params[:login_name], :password => params[:plain_password]
        }
      end
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to session_new_url
  end
end
