class ContactersController < ApplicationController
  
  before_filter :require_contacter_available, :only => [:show]
  before_filter :require_contacter_editable, :only => [:edit, :update, :destroy]
  
  # GET /contacters
  # GET /contacters.xml
  def index
    @page = Page.new

    if params[:search] == nil

      @contacters = @page.sort_page_model({
        :model_name => "Contacter",
        :sort_by => 'updated_at', 
        :sort_order => 'DESC', 
        :limit => 5,
        :conditions => ['available = ? and (user_id = ? or (for_public = ?))', 
          true, session[:user_id], true],
        :page_no =>  params[:page_no]
      })

    else

      @contacters = @page.search_sort_page_model({
        :model_name => "Contacter",
        :search_by => ['name', 'company', 'email', 'address', 'phone', 'cellphone', 'note'],
        :search_value => params[:search],
        :sort_by => 'updated_at', 
        :sort_order => 'DESC',
        :limit => 5,
        :conditions => ['available = ? and (user_id = ? or (for_public = ?))',
          true, session[:user_id], true],
        :page_no =>  params[:page_no]
      })

    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contacters }
    end
  end

  # GET /contacters
  # GET /contacters.xml
  def bin
    @page = Page.new

    if params[:search] == nil

      @contacters = @page.sort_page_model({
        :model_name => "Contacter",
        :sort_by => 'updated_at', 
        :sort_order => 'DESC', 
        :limit => 5,
        :conditions => ['available = ? and (user_id = ?)', 
          false, session[:user_id]],
        :page_no =>  params[:page_no]
      })

    else

      @contacters = @page.search_sort_page_model({
        :model_name => "Contacter",
        :search_by => ['name', 'company', 'email', 'address', 'phone', 'cellphone', 'note'],
        :search_value => params[:search],
        :sort_by => 'updated_at', 
        :sort_order => 'DESC',
        :limit => 5,
        :conditions => ['available = ? and (user_id = ?)', 
          false, session[:user_id]],
        :page_no =>  params[:page_no]
      })

    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contacters }
    end
  end
  
  # GET /contacters/1
  # GET /contacters/1.xml
  def show
    @contacter = Contacter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contacter }
    end
  end

  # GET /contacters/new
  # GET /contacters/new.xml
  def new
    @contacter = Contacter.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contacter }
    end
  end

  # GET /contacters/1/edit
  def edit
    @contacter = Contacter.find(params[:id])
  end

  # POST /contacters
  # POST /contacters.xml
  def create
    @contacter = Contacter.new(params[:contacter])
    @contacter.user_id = session[:user_id]

    respond_to do |format|
      if @contacter.save
        format.html { redirect_to(@contacter, :notice => 'Contacter was successfully created.') }
        format.xml  { render :xml => @contacter, :status => :created, :location => @contacter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contacter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contacters/1
  # PUT /contacters/1.xml
  def update
    @contacter = Contacter.find(params[:id])
    params[:contacter][:available] = true

    respond_to do |format|
      if @contacter.update_attributes(params[:contacter])
        format.html { redirect_to(@contacter, :notice => 'Contacter was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contacter.errors, :status => :unprocessable_entity }
      end
    end
  end

  def to_bin
    @contacter = Contacter.find(params[:id])
    @contacter.available = false
    @contacter.save

    respond_to do |format|
      format.html { redirect_to(contacters_url) }
      format.xml  { head :ok }
    end
  end
  
  # DELETE /contacters/1
  # DELETE /contacters/1.xml
  def destroy
    @contacter = Contacter.find(params[:id])
    @contacter.destroy

    respond_to do |format|
      format.html { redirect_to(bin_contacters_url) }
      format.xml  { head :ok }
    end
  end
  
  def require_contacter_available
    if params[:id]
      contacter = Contacter.find_by_id(params[:id])
      if (!contacter) || ((contacter.for_public == false || contacter.available == false ) && contacter.user_id != session[:user_id])
        puts 'rediract'
        redirect_to contacters_url
      end
    end
  end
  
  def require_contacter_editable
    if params[:id]
      contacter = Contacter.find_by_id(params[:id])
      if !contacter || contacter.user_id != session[:user_id]
        redirect_to contacters_url
      end
    end
  end
  
end
