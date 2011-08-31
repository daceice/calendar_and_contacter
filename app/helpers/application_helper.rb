module ApplicationHelper
  
  def show_error
    result = flash[:error]
    flash[:error] = ''
    result
  end
  
  def show_notice
    result = flash[:notice]
    flash[:notice] = ''
    result
  end
  
  # ==================================
  
  def ava_to_s(available)
    if available
      return '可用'
    else
      return '不可用'
    end
  end
  
  def bool_to_s(available)
    if available
      return '是'
    else
      return '否'
    end
  end
  
  # ==================================
  
  
  def shift_time(time_to_shift)
    if time_to_shift
      return time_to_shift.strftime('%Y-%m-%d %H:%M:%S')
    else
      return ''
    end
  end
  
  def shift_date(time_to_shift)
    if time_to_shift
      return time_to_shift.strftime('%Y-%m-%d')
    else
      return ''
    end
  end
  
  # ==================================
  
  def admin_login
    current_user = User.find_by_id(session[:user_id])
    if current_user == nil || current_user.id != 1
      return false
    else
      return true
    end
    
  end
  
  # ==================================
  
  
  def paging(path, count, limit = 20, params = {}, break_signal = ' ')
    result = ''
    page_count = ((count - 1)/limit) + 1
    result += page_count.to_s + ' page' + (page_count != 1 ? 's' : '') + ' in total '
    result += page_icon( path, count, limit, params, break_signal)
    return result
  end
  
  def page_admin(path, count, limit = 20, params = {}, break_signal = ' ')
    result = ''
    result += '- ' + count.to_s + ' record' + (count > 1 ? 's' : '') + ' in total - '
    result += page_icon( path, count, limit, params, break_signal)
    return result
  end
  
  
end
