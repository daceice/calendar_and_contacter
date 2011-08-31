class CalendarsController < ApplicationController
  
  before_filter :require_calendar_available, :include => [:edit, :update, :destroy, :show]
  before_filter :require_calendar_editable, :include => [:edit, :update, :destroy]
  
  # GET /calendars
  # GET /calendars.xml
  def index   
    @page = Page.new

    if params[:search] == nil

      @calendars = @page.sort_page_model({
        :model_name => "Calendar",
        :sort_by => 'date', 
        :sort_order => 'DESC', 
        :conditions => ['available = ? and (user_id = ? or (for_public = ?))', 
          true, session[:user_id], true],
        :page_no =>  params[:page_no]
      })

    else

      @calendars = @page.search_sort_page_model({
        :model_name => "Calendar",
        :search_by => ['note'],
        :search_value => params[:search],
        :sort_by => 'date', 
        :sort_order => 'DESC',
        :page_no =>  params[:page_no]
      })

    end

    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @calendars }
    end
  end

  # GET /calendars/1
  # GET /calendars/1.xml
  def show
    @calendar = Calendar.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @calendar }
    end
  end

  # GET /calendars/new
  # GET /calendars/new.xml
  def new
    @calendar = Calendar.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @calendar }
    end
  end

  # GET /calendars/1/edit
  def edit
    @calendar = Calendar.find(params[:id])
  end

  # POST /calendars
  # POST /calendars.xml
  def create
    @calendar = Calendar.new(params[:calendar])
    @calendar.user_id = session[:user_id]

    respond_to do |format|
      if @calendar.save
        format.html { redirect_to(@calendar, :notice => 'Calendar was successfully created.') }
        format.xml  { render :xml => @calendar, :status => :created, :location => @calendar }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @calendar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /calendars/1
  # PUT /calendars/1.xml
  def update
    @calendar = Calendar.find(params[:id])

    respond_to do |format|
      if @calendar.update_attributes(params[:calendar])
        format.html { redirect_to(@calendar, :notice => 'Calendar was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @calendar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /calendars/1
  # DELETE /calendars/1.xml
  def destroy
    @calendar = Calendar.find(params[:id])
    @calendar.available = false
    @calendar.save

    respond_to do |format|
      format.html { redirect_to(calendars_url) }
      format.xml  { head :ok }
    end
  end
  
  
  def require_calendar_available
    if params[:id]
      calendar = Calendar.find_by_id(params[:id])
      if !calendar || calendar.available == false
        redirect_to calendars_url
      end
    end
  end
  
  def require_calendar_editable
    if params[:id]
      calendar = Calendar.find_by_id(params[:id])
      if !calendar || calendar.user_id != session[:user_id]
        redirect_to calendars_url
      end
    end
  end
  
end
