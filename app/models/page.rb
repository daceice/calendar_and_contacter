class Page
  
  # total quantity of all the records
  def count
    return @count
  end
  
  # limited quantity on one page
  def limit
    return @limit
  end
  
  # == Paging
  
  # Input 
  #  model_name: model name
  #  conditions: conditions in sql select
  #  limit: quantity on a page
  #  page_no: page number
  def page_model( parameter )
    
    model_name = parameter[:model_name]
    conditions = parameter[:conditions]
    limit = parameter[:limit] == nil ? 20 : parameter[:limit].to_i
    page_no = parameter[:page_no] == nil ? 0 : parameter[:page_no].to_i
    
    if model_name == nil
      return []
    else
      @limit = limit
      offset = limit * page_no
      datas = model_name.constantize.find(:all, :limit => limit, :offset => offset, :conditions => conditions)    
      @count = model_name.constantize.count(:conditions => conditions) 
      return datas
    end
  end

  # Input 
  #  model_name: model name
  #  conditions: conditions in sql select
  #  refer_conditions: conditions related to other model
  #   it is an array of arraies. the inner one has four value, as following
  #    Refer_model: refer model name
  #    Refer_column: colum name
  #    Refer_by: equal, unequal, like, larger, less, larger_or_equal, less_or_equal
  #    Refer_condition_value: string
  #   it is something like:
  #    [["role", "name", "like", "token"]]
  #  limit: quantity on a page
  #  page_no: page number
  def page_model_refer( parameter)
   
    model_name = parameter[:model_name]
    conditions = parameter[:conditions]
    joins = parameter[:joins]
    limit = parameter[:limit] == nil ? 20 : parameter[:limit].to_i
    page_no = parameter[:page_no] == nil ? 0 : parameter[:page_no].to_i
        
    if model_name == nil
      return []
    else
      @limit = limit
      offset = limit * page_no
      result = model_name.constantize.find(:all, :include => joins, :limit => limit, :offset => offset, :conditions => conditions)
      @count = model_name.constantize.count(:include => joins, :conditions => conditions) 
      return result
    end
  end
  
  
  #== Sorting and paging
  
  # Input 
  #  model_name: model name
  #  conditions: conditions in sql select
  #  sort_by: the local column that sorting is according to
  #  sort_order: the order the sorting is done
  #  conv_utf_8: whether there is a need to convert GBK to Utf-8
  #  limit: quantity on a page
  #  page_no: page number
  def sort_page_model( parameter )

    model_name = parameter[:model_name]
    conditions = parameter[:conditions]
    sort_by = parameter[:sort_by] == nil ? "created_at" : parameter[:sort_by]
    sort_order = parameter[:sort_order] == nil ? "DESC" : parameter[:sort_order]
    conv_utf_8 = parameter[:conv_utf_8] == nil ? false : parameter[:conv_utf_8]
    limit = parameter[:limit] == nil ? 20 : parameter[:limit].to_i
    page_no = parameter[:page_no] == nil ? 0 : parameter[:page_no].to_i
    
    if model_name == nil
      return []
    else
      @limit = limit
      offset = limit * page_no
      result = []
      if conv_utf_8
        #puts "conv "
        datas = sort_model( model_name, conditions, sort_by, sort_order, conv_utf_8)
        @count = datas.length
        result = datas[offset, limit]
      else
        #puts "not conv "
        result = model_name.constantize.find(:all, :limit => limit, :offset => offset, :order=>"#{sort_by} #{sort_order}", :conditions => conditions)    
        @count = model_name.constantize.count(:conditions => conditions)    
      end
      #puts "---------#{sort_by} #{sort_order}"
      return result
    end
  end
    
    
  # Input 
  #  model_name: model name
  #  conditions: conditions in sql select
  #  refer_conditions: conditions related to other model
  #   it is an array of arraies. the inner one has four value, as following
  #    Refer_model: refer model name
  #    Refer_column: colum name
  #    Refer_by: equal, unequal, like, larger, less, larger_or_equal, less_or_equal
  #    Refer_condition_value: string
  #   it is something like:
  #    [["role", "name", "like", "token"]]
  #  refer_model: the model of the column used to sort located in. the entrance is a method of local one
  #  sort_by: the local column that sorting is according to
  #  sort_order: the order the sorting is done
  #  conv_utf_8: whether there is a need to convert GBK to Utf-8
  #  limit: quantity on a page
  #  page_no: page number  
  def sort_page_model_refer( parameter )
    
    model_name = parameter[:model_name]
    #puts "=====#{model_name}"
    conditions = parameter[:conditions]
    joins = parameter[:joins]
    sort_by = parameter[:sort_by] == nil ? model_name.constantize.table_name+".created_at" : parameter[:sort_by]
    sort_order = parameter[:sort_order] == nil ? "DESC" : parameter[:sort_order]
    conv_utf_8 = parameter[:conv_utf_8] == nil ? false : parameter[:conv_utf_8]
    limit = parameter[:limit] == nil ? 20 : parameter[:limit].to_i
    page_no = parameter[:page_no] == nil ? 0 : parameter[:page_no].to_i
    
    if model_name == nil
      return []
    else
      @limit = limit
      offset = limit * page_no
      datas = sort_model_refer( model_name, joins, conditions, sort_by, sort_order, conv_utf_8)
      @count = datas.length
      return datas[offset, limit]
    end
  end
  

  #== Searching and Sorting and Paging
  
  # Input 
  #  model_name: model name
  #  conditions: conditions in sql select
  #  search_by: the local columns that used to search
  #   something like ["name", "nick_name"]
  #  search_value: the value used to compare in search
  #  sort_by: the local column that sorting is according to
  #  sort_order: the order the sorting is done
  #  conv_utf_8: whether there is a need to convert GBK to Utf-8
  #  limit: quantity on a page
  #  page_no: page number
  def search_sort_page_model( parameter )

    model_name = parameter[:model_name]
    conditions = parameter[:conditions]
    search_by = parameter[:search_by] == nil ? [] : parameter[:search_by]
    search_value = parameter[:search_value] == nil ? "" : parameter[:search_value]
    sort_by = parameter[:sort_by] == nil ? "created_at" : parameter[:sort_by]
    sort_order = parameter[:sort_order] == nil ? "DESC" : parameter[:sort_order]
    conv_utf_8 = parameter[:conv_utf_8] == nil ? false : parameter[:conv_utf_8]
    limit = parameter[:limit] == nil ? 20 : parameter[:limit].to_i
    page_no = parameter[:page_no] == nil ? 0 : parameter[:page_no].to_i
    
    if model_name == nil
      return []
    else
      datas = search_sort_model( model_name, conditions, search_by, search_value, [sort_by, sort_order, conv_utf_8])
      @limit = limit
      offset = limit * page_no
      @count = datas.length
      return datas[offset, limit]
    end
  end
  
  # Input 
  #  model_name: model name
  #  conditions: conditions in sql select
  #  refer_conditions: conditions related to other model
  #   it is an array of arraies. the inner one has four value, as following
  #    Refer_model: refer model name
  #    Refer_column: colum name
  #    Refer_by: equal, unequal, like, larger, less, larger_or_equal, less_or_equal
  #    Refer_condition_value: string
  #   it is something like:
  #    [["role", "name", "like", "token"]]
  #  search_by: the local columns that used to search
  #   something like ["name", "nick_name"]
  #  search_refer_by: the related models and thier colummns used to seach
  #   something like [["User",["name", "nick_name"]]]
  #  search_value: the value used to compare in search
  #  refer_model: the model of the column used to sort located in. the entrance is a method of local one
  #  sort_by: the local column that sorting is according to
  #  sort_order: the order the sorting is done
  #  conv_utf_8: whether there is a need to convert GBK to Utf-8
  #  limit: quantity on a page
  #  page_no: page number
  def search_sort_page_model_refer( parameter )
    
    
    model_name = parameter[:model_name]
    conditions = parameter[:conditions]
    joins = parameter[:joins]
    search_by = parameter[:search_by] == nil ? [] : parameter[:search_by]
    search_value = parameter[:search_value] == nil ? "" : parameter[:search_value]
    sort_by = parameter[:sort_by] == nil ? model_name.constantize.table_name+".created_at" : parameter[:sort_by]
    sort_order = parameter[:sort_order] == nil ? "DESC" : parameter[:sort_order]
    conv_utf_8 = parameter[:conv_utf_8] == nil ? false : parameter[:conv_utf_8]
    limit = parameter[:limit] == nil ? 20 : parameter[:limit].to_i
    page_no = parameter[:page_no] == nil ? 0 : parameter[:page_no].to_i
    
    if model_name == nil
      return []
    else
      datas = search_sort_model_refer( model_name, joins, conditions, search_by, search_value, [sort_by, sort_order, conv_utf_8])
      puts "----!!!----#{datas.inspect}"
      @limit = limit
      offset = limit * page_no
      @count = datas.length
      return datas[offset, limit]
    end
  end
  
  #== Paging
  
  # Input data for paging, quantity on a page, and page number
  def page_data( datas, limit = 20, page_no = 0)
    @limit = limit
    offset = limit * page_no
    @count = datas.length
    return datas[offset, limit]
  end

  #== Sorting
  
  
  # Input data for sorting, column to sort, sort order, and whether conversion is needed
  def sort_data( datas, sort_by = nil, sort_order = "DESC", conv_utf_8 = false)
    if sort_by
      if conv_utf_8 # sort after conversion
        conv = Iconv.new("GBK", "utf-8")
        datas.sort! {|x, y| conv.iconv(x[sort_by.to_sym]) <=> conv.iconv(y[sort_by.to_sym])}
      else # sort at once
        datas.sort! {|x, y| x[sort_by.to_sym] <=> y[sort_by.to_sym]}
      end 
      if sort_order == "DESC" # get reversed data
        datas.reverse!
      end
    end
    return datas
  end
  
  # Input datas for sorting, refer model, column to sort, sort order, and whether conversion is needed
  def sort_data_refer( datas, refer_model = nil, sort_by = nil, sort_order = "DESC", conv_utf_8 = false)
    if sort_by
      if refer_model == nil # with no refer model, just sort the data with local column
        result = sort_data(datas, sort_by, sort_order, conv_utf_8 )
      else # use column from refer model to sort
        if conv_utf_8 
          conv = Iconv.new("GBK", "utf-8")
          datas.sort! {|x, y| conv.iconv(x.method(refer_model).call[sort_by.to_sym]) <=> conv.iconv(y.method(refer_model).call[sort_by.to_sym])}
        else
          datas.sort! {|x, y| x.method(refer_model).call[sort_by.to_sym] <=> y.method(refer_model).call[sort_by.to_sym]}
        end
        result = datas
        if sort_order == "DESC"
          result.reverse!
        end
      end
    else
      result = datas
    end
    return result
  end
  
  
  # Input model name, conditions, column to sort, sort order, and whether conversion is needed
  def sort_model( model_name, conditions = nil, sort_by = nil, sort_order = "DESC", conv_utf_8 = false)
    result = []
    if sort_by
      if conv_utf_8
        datas = model_name.constantize.find(:all, :conditions => conditions)
        result = sort_data( datas, sort_by, sort_order, conv_utf_8)
      else
        result = model_name.constantize.find(:all, :order=>"#{sort_by} #{sort_order}", :conditions => conditions)    
      end
      #puts "---------2#{sort_by} #{sort_order}"
    else
      result = model_name.constantize.find(:all, :conditions => conditions)    
    end
    return result
  end
  
  # Input model name, conditions, reference model, conditions for reference model( using refer_model, refer_colum, refer_by, 
  # and refer_conditions), column to sort, sort order, and whether conversion is needed
  #  Refer_conditions: array of arraies. the inner one has four value, as following
  #   Refer_model: refer model name
  #   Refer_column: colum name
  #   Refer_by: equal, unequal, like, larger, less, larger_or_equal, less_or_equal
  #   Refer_condition_value: string
  def sort_model_refer( model_name, joins = nil, conditions = nil, sort_by = nil, sort_order = "DESC", conv_utf_8 = false)
    #puts "bbbbb-----#{model_name}"
    result = []
    if sort_by
      if conv_utf_8
        datas = model_name.constantize.find(:all, :include => joins, :conditions => conditions)
        index = (sort_by =~/\./)
        if index
          refer_model = sort_by[0, index]
          sort_by = sort_by[index + 1, sort_by.length - index - 1]
        else
          sort_by = sort_by
          refer_model = nil
        end
        result = sort_data_refer( datas, refer_model, sort_by, sort_order, conv_utf_8)
      else
        result = model_name.constantize.find(:all, :include => joins, :order => "#{sort_by} #{sort_order}", :conditions => conditions)
      end
    else
      result = model_name.constantize.find(:all, :include => joins, :conditions => conditions)    
    end
    return result
  end
  

  
  #== Sorting and paging
  
  # sort datas and page
  def sort_page_data( datas, sort_by = nil, sort_order = "DESC", conv_utf_8 = false, page_params = [ 20, 0])
    
    limit = page_params[0]
    page_no = page_params[1]
    
    @limit = limit
    offset = limit * page_no
    result = sort_data( datas, sort_by, sort_order, conv_utf_8)
    @count = result.length
    return result[offset, limit]
  end
  
  # sort datas with related model and page
  def sort_page_data_refer( datas, refer_model = nil, sort_by = nil, sort_order = "DESC", conv_utf_8 = false, page_params = [ 20, 0])
    
    limit = page_params[0]
    page_no = page_params[1]
    
    @limit = limit
    offset = limit * page_no
    if refer_model == nil
      result = sort_data( datas, sort_by, sort_order, conv_utf_8)
    else
      result = sort_data_refer( datas, refer_model, sort_by, sort_order, conv_utf_8)
    end
    @count = result.length
    return result[offset, limit]
  end
  
  #== Searching
  
  # Search by is an array, indicating that, if any field of rows included by search by is equal to search_value,
  # return it.
  # Search by here is something like ["name", "nick_name"]
  # Search value is a single value or an array with same length of Search by
  def search_data( datas, search_by = [], search_value = "")
    result = []
    
    if search_value.class == Array && search_by.length == search_value.length
      length = search_by.length
      datas.each do |data|
        searched = false
        0.upto length-1 do |i|
          if searched == false && (data[(search_by[i]).to_sym] =~/#{search_value[i]}/)
            searched = true
          end
        end  
        if searched == true
          result << data
        end
      end
    else
      datas.each do |data|
        searched = false
        search_by.each do |s_b|
          if searched == false && (data[s_b.to_sym] =~/#{search_value}/)
            searched = true
          end
        end  
        if searched == true
          result << data
        end
      end
    end
    return result
  end
  
  # Search by here is something like ["name", "nick_name"]
  # Search value is a single value or an array with same length of Search by
  # Search refer by here is something like {"user"=>["name", "nick_name"]}
  # or, when Search value is an array, is something like {"user"=>[["name", 'value'], ["nick_name",'value']]}
  def search_data_refer( datas, search_by = [], search_refer_by = {}, search_value = "")
    result = []
    
    if search_value.class == Array && search_by.length == search_value.length
      length = search_by.length
      datas.each do |data|
        searched = false
        0.upto length-1 do |i|
          if searched == false && (data[(search_by[i]).to_sym] =~/#{search_value[i]}/)
            searched = true
          end
        end  
        search_refer_by.keys.each do |key|
          search_refer_by[key].each do |s_r_b_column|
            if searched == false && data.method(key).call && (data.method(key).call[s_r_b_column[0].to_sym] =~/#{s_r_b_column[1]}/)
              searched = true
            end
          end
        end
        if searched == true
          result << data
        end
      end
    else
    
      datas.each do |data|
        searched = false
        search_by.each do |s_b|
          if searched == false && (data[s_b.to_sym] =~/#{search_value}/)
            searched = true
          end
        end 
        search_refer_by.keys.each do |key|
          search_refer_by[key].each do |s_r_b_column|
            if searched == false && data.method(key).call && (data.method(key).call[s_r_b_column.to_sym] =~/#{search_value}/)
              searched = true
            end
          end
        end
        if searched == true
          result << data
        end
      end
    end
    return result
  end
  
  # search through local columns in a model
  def search_model( model_name, conditions = nil, search_by = [], search_value = "")
    result = []   
    conditions = join_the_conditions_with_search(conditions, search_by, search_value)
    result = model_name.constantize.find(:all, :conditions => conditions)
    #puts "new_conditions"+new_conditions
    #puts "array"+conditions.inspect
    return result
  end
  
  # Search_refer by here is something like [["user",["name","nick_name"]]["title", ["name"]]]
  def search_model_refer( model_name, joins = nil, conditions = nil, search_by = [], search_value = "")
    result = []
    conditions = join_the_conditions_with_search(conditions, search_by, search_value)
    result = model_name.constantize.find(:all, :include => joins, :conditions => conditions)
    return result
  end
  
  
  
  #== Searching and Sorting
  
  # search and sort datas
  def search_sort_data( datas, search_by = [], search_value = "", sort_refer_params = [nil, "DESC", false])
    sort_by = sort_refer_params[0]
    sort_order = sort_refer_params[1]
    conv_utf_8 = sort_refer_params[2]
    datas = search_data( datas, search_by, search_value)
    result = sort_data( datas, sort_by, sort_order, conv_utf_8)
    return result
  end
  
  # search and sort datas with related model
  def search_sort_data_refer( datas, search_by = [], search_refer_by = {}, search_value = "", sort_refer_params = [ nil, nil, "DESC", false])
    refer_model = sort_refer_params[0]
    sort_by = sort_refer_params[1]
    sort_order = sort_refer_params[2]
    conv_utf_8 = sort_refer_params[3]
    
    datas = search_data_refer( datas,search_by, search_refer_by, search_value)
    result = sort_data_refer( datas, refer_model, sort_by, sort_order, conv_utf_8)
    return result
  end
  
  # search from a model
  def search_sort_model( model_name, conditions = nil, search_by = [], search_value = "", sort_refer_params = [ nil, "DESC", false])
    sort_by = sort_refer_params[0]
    sort_order = sort_refer_params[1]
    conv_utf_8 = sort_refer_params[2]
    
    result = []
    conditions = join_the_conditions_with_search(conditions, search_by, search_value)
    
    if sort_by
      if conv_utf_8
        datas = model_name.constantize.find(:all, :conditions => conditions)
        result = sort_data( datas, sort_by, sort_order, conv_utf_8)
      else
        result = model_name.constantize.find(:all, :order=>"#{sort_by} #{sort_order}", :conditions => conditions)    
      end
      #puts "---------2#{sort_by} #{sort_order}"
    else
      result = model_name.constantize.find(:all, :conditions => conditions)    
    end
    return result
  end
  
  # search from a model with related model
  def search_sort_model_refer( model_name, joins = nil, conditions = nil, search_by = [], search_value = "", sort_refer_params = [nil, "DESC", false])
    sort_by = sort_refer_params[0]
    sort_order = sort_refer_params[1]
    conv_utf_8 = sort_refer_params[2]
    
    conditions = join_the_conditions_with_search(conditions, search_by, search_value)
    if sort_by
      if conv_utf_8
        datas = model_name.constantize.find(:all, :include => joins, :conditions => conditions)
        index = (sort_by =~/\./)
        if index
          refer_model = sort_by[0, index]
          sort_by = sort_by[index + 1, sort_by.length - index - 1]
        else
          sort_by = sort_by
          refer_model = nil
        end
        result = sort_data_refer( datas, refer_model, sort_by, sort_order, conv_utf_8)
      else
        puts "---------2#{sort_by} #{sort_order}"
        result = model_name.constantize.find(:all, :include => joins, :order=>"#{sort_by} #{sort_order}", :conditions => conditions)    
      end
    else
      result = model_name.constantize.find(:all, :conditions => conditions)    
    end
    
    return result    
  end
  
  #== Searching and Sorting and Paging
  
  # search and sort datas and page
  def search_sort_page_data( datas, search_by = [], search_value = "", sort_refer_params = [ nil, "DESC", false], page_params = [ 20, 0])
    
    limit = page_params[0].to_i
    page_no = page_params[1].to_i
    
    datas = search_sort_data( datas, search_by, search_value, sort_refer_params )
    
    @limit = limit
    offset = limit * page_no
    @count = datas.length
    return datas[offset, limit]
  end
  
  # search and sort datas with related model and page
  def search_sort_page_data_refer( datas, search_by = [], search_refer_by = {}, search_value = "", sort_refer_params = [ nil, nil, "DESC", false], page_params = [ 20, 0])

    limit = page_params[0].to_i
    page_no = page_params[1].to_i
    
    datas = search_sort_data_refer( datas, search_by, search_refer_by, search_value, sort_refer_params)
    
    @limit = limit
    offset = limit * page_no
    @count = datas.length
    return datas[offset, limit]
  end
  
  # total quantity of records
  @count = 0
  
  # limit quantity in one page
  @limit = 0
  
  def join_the_conditions_with_search(conditions = nil, search_by = [], search_value = "")
    
    new_conditions = ""
    conditions == nil ? new_conditions = "" : new_conditions = conditions[0]
    
    search_conditions = ""
    
    if search_value.class == Array && search_by.length == search_value.length
      length = search_by.length
      if search_by.length != 0
        if search_by.length == 1
          search_conditions = "#{search_by[0]} like ?"
        elsif search_by.length > 1
          search_columns = []
          0.upto length-1 do |i|
            search_columns << search_by[i] + " like ? "
          end
          search_conditions = search_columns.inject{|s, t| s + " or " + t }
        end
        if conditions == nil
          conditions = []
          new_conditions = search_conditions
        else
          new_conditions = "("+new_conditions+")"+" and "+"("+search_conditions+")"
        end
        conditions[0] = new_conditions
        0.upto length-1 do |i|
          conditions << "%"+search_value[i]+"%"
        end
      end    
    else
      if search_by.length != 0
        if search_by.length == 1
          search_conditions = "#{search_by[0]} like ?"
        elsif search_by.length > 1
          search_columns = []
          search_by.each do |s|
            search_columns << s + " like ? "
          end
          search_conditions = search_columns.inject{|s, t| s + " or " + t }
        end
        if conditions == nil
          conditions = []
          new_conditions = search_conditions
        else
          new_conditions = "("+new_conditions+")"+" and "+"("+search_conditions+")"
        end
        conditions[0] = new_conditions
        1.upto search_by.length do |i|
          conditions << "%"+search_value+"%"
        end
      end
    end
    return conditions
  end
    

end
