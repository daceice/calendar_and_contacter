class DataSourcesController < ApplicationController
  def all_company
    @arr_company = []
    @output = ""
    if params[:term]
      @companies = Contacter.all(:conditions => ['company LIKE ?', '%'+ params[:term].chomp(' ')+'%'])
    else
      @companies = Contacter.all()
    end
    puts @companies.inspect
    @companies.each do |company|
      if company.company && company.company != ''
        @arr_company << company.company
      end
    end
    puts @arr_company.inspect
    @output = (@arr_company.uniq).to_json
    puts @output.inspect
    respond_to do |format|
      format.js { render :json => @output }
    end
  end
end
