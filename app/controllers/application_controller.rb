class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :require_user_login
  
  def notify_success(content)
    flash[:notice] = content
    flash[:error] = ''
    session[:notice] = content
  end
  
  def notify_failure(content)
    flash[:error] = content
    flash[:notice] = ''
    session[:notice] = content
  end
  
  # ==================================
  
  def return_to_return_to(backup_path, return_url = nil)
    if return_url && return_url != nil && return_url != ''
      return_to = return_url
    elsif session[:return_to]
      return_to = session[:return_to]
      session[:return_to] = nil
    else
      return_to = backup_path
    end
    redirect_to return_to
  end
  
  # ==================================

  def fetch_current_user
    current_user = User.find_by_id(session[:user_id])
    if current_user #&& current_user.available
      return current_user
    else
      return nil
    end
  end
  
  def require_user_login
    if params[:controller] != 'session'
      @current_user = fetch_current_user
      if @current_user == nil
        if request.get?
          return_url = request.url
        else
          return_url = request.referer
        end
        redirect_to session_new_url(:return_url => return_url)
      end
    end
  end
  
  def require_admin_login
    if params[:controller] != 'session'
      @current_user = fetch_current_user
      if @current_user == nil || @current_user.id != 1
        if request.get?
          return_url = request.url
        else
          return_url = request.referer
        end
        redirect_to new_session_url(:return_url => return_url)
      end
    end
  end
  
end
