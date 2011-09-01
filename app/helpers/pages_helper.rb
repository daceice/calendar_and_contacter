module PagesHelper
  
  def sort_icon( path, sort_by = 'created_at', other_params = {} )
    parameter = {}
    parameter[:sort_by] = sort_by
    other_params.keys.each do |key|
      parameter[key] = other_params[key]
    end
    result = ""
    parameter[:sort_order] = 'DESC'
    #path = yield(parameter)
    
    result += link_to image_tag("down_arrow.png", :border => 0), self.send(path, parameter)#eval("#{path}(parameter)")
    result += " "
    parameter[:sort_order] = 'ASC'
    #path = yield(parameter)
    result += link_to image_tag("up_arrow.png", :border => 0), self.send(path, parameter)#eval("#{path}(parameter)")
    return result
  end
  
  def sort_down_icon( path, sort_by = 'created_at', other_params = {})
    parameter = {}
    parameter[:sort_by] = sort_by
    other_params.keys.each do |key|
      parameter[key] = other_params[key]
    end
    parameter[:sort_order] = 'DESC'
    link_to image_tag("down_arrow.png", :border => 0), self.send(path, parameter)
    
  end
  
  def sort_up_icon(path, sort_by = 'created_at', other_params = {} )
    parameter = {}
    parameter[:sort_by] = sort_by
    other_params.keys.each do |key|
      parameter[key] = other_params[key]
    end
    parameter[:sort_order] = 'ASC'
    link_to image_tag("up_arrow.png", :border => 0), self.send(path, parameter)
  end
  
  
  
  
  
  def page_prev(path, count, limit = 20, params = {})
    result = ""
    page = 2
    params[:page_no] != nil ? this = params[:page_no].to_i : this = 0 
    
    this + page > (count - 1) / limit ? ending = (count - 1) / limit : ending = this + page
    this - page > 0 ? start = this - page : start = 0

    if this > 0	
      parameter = params
      parameter[:page_no] = this - 1
    	result += link_to( 'prev', self.send(path, parameter))
    end
    return result
  end
  
  
  def page_first(path, count, limit = 20, params = {})
    result = ""
    page = 2
    params[:page_no] != nil ? this = params[:page_no].to_i : this = 0 
    
    this + page > (count - 1) / limit ? ending = (count - 1) / limit : ending = this + page
    this - page > 0 ? start = this - page : start = 0

    if start > 0	
      parameter = params
      parameter[:page_no] = 0
    	result += link_to( '1', self.send(path, parameter))
      if start > 1
        result += "..."
      end
    end
    return result
  end
  
  
  def page_all(path, count, limit = 20, params = {})
    result = ""
    page = 2
    params[:page_no] != nil ? this = params[:page_no].to_i : this = 0 
    
    this + page > (count - 1) / limit ? ending = (count - 1) / limit : ending = this + page
    this - page > 0 ? start = this - page : start = 0

    start.upto ending do |i|
    	if i == this
    	  result += '<strong>' + (i + 1).to_s + '</strong>'
    	else
        parameter = params
        parameter[:page_no] = i
      	result += link_to( (i + 1).to_s, self.send(path, parameter))
    	end
    end
    return result
  end
  
  
  def page_last(path, count, limit = 20, params = {})
    result = ""
    page = 2
    params[:page_no] != nil ? this = params[:page_no].to_i : this = 0 
    
    this + page > (count - 1) / limit ? ending = (count - 1) / limit : ending = this + page
    this - page > 0 ? start = this - page : start = 0


    if ending < ( count - 1) / limit
    	if ending + 1 < ( count - 1 ) / limit
        result += " ... "
      end
      parameter = params
      parameter[:page_no] = (count - 1) / limit
    	result += link_to( ((count - 1) / limit + 1).to_s, self.send(path, parameter))
    end
    return result
  end
  
  
  def page_next(path, count, limit = 20, params = {})
    result = ""
    page = 2
    params[:page_no] != nil ? this = params[:page_no].to_i : this = 0 
    
    this + page > (count - 1) / limit ? ending = (count - 1) / limit : ending = this + page
    this - page > 0 ? start = this - page : start = 0


    if this < ( count - 1) / limit
      parameter = params
      parameter[:page_no] = this + 1
    	result += link_to( 'next', self.send(path, parameter))
    end
    return result
  end
  
  
  
  
  
  
  def page_icon(path, count, limit = 20, params = {}, break_signal = ' ')
    result = ""
    page = 2
    params[:page_no] != nil ? this = params[:page_no].to_i : this = 0 
    
    this + page > (count - 1) / limit ? ending = (count - 1) / limit : ending = this + page
    this - page > 0 ? start = this - page : start = 0

    if this > 0	
      parameter = params
      parameter[:page_no] = this - 1
    	result += link_to( 'prev', self.send(path, parameter))
    	result += break_signal
    end

    if start > 0	
      parameter = params
      parameter[:page_no] = 0
    	result += link_to( '1', self.send(path, parameter))
    	result += break_signal
      if start > 1
        result += "..."
      	result += break_signal
      end
    end

    start.upto ending do |i|
    	if i == this
    	  result += '<strong>' + (i + 1).to_s + '</strong>'
      	result += break_signal
    	else
        parameter = params
        parameter[:page_no] = i
      	result += link_to( (i + 1).to_s, self.send(path, parameter))
      	result += break_signal
    	end
    end

    if ending < ( count - 1) / limit
    	if ending + 1 < ( count - 1 ) / limit
        result += "..."
      	result += break_signal
      end
      parameter = params
      parameter[:page_no] = (count - 1) / limit
    	result += link_to( ((count - 1) / limit + 1).to_s, self.send(path, parameter))
    	result += break_signal
    end

    if this < ( count - 1) / limit
      parameter = params
      parameter[:page_no] = this + 1
    	result += link_to( 'next', self.send(path, parameter))
    	result += break_signal
    end
    return result
  end
  
  
end
