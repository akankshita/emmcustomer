class CountriesController < ApplicationController
    respond_to :json, :html
  def index
    if params[:state] == "1"
        @state = 0
        sort = "ASC"
    else
        @state = 1
        sort = "DESC"
    end
    case  params[:sorton]
        when    "1"
            field = 'first_name'
        when    "2"
            field = 'email'
        when    "3"
            field = 'status'
    else
        field = 'created_at'
    end
    if params[:keyword]!='' && params[:keyword]!=nil && params[:option]!='' && params[:option]!=nil
        if params[:alpha_search] == 'Yes'
        
            keyword = [" #{params[:option] .strip()} LIKE ?", "%#{params['keyword'].strip()}%"]
        else
            keyword = [" #{params[:option] .strip()} LIKE ?", "%#{params['keyword'].strip()}%"]
        end
    else
        keyword = []
    end
    order_by = "#{field} #{sort}"
    
    @countries = Country.paginate(:page => params[:page], :per_page => 10,:conditions => keyword, :order => order_by)
  end

  def new
    @country = Country.new

  end

  def edit
    @country = Country.find(params[:id])
  end

  def create
    @country = Country.new(params[:country])
  
    respond_to do |format|
      if @country.save
        flash[:msg] = 'Country was successfully created.'
        format.html { redirect_to :controller => 'countries', :action => 'index' }
      else
        format.html { render action: "new" }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @country = Country.find(params[:id])
    respond_to do |format|
      if @country.update_attributes(params[:country])
        flash[:msg] = 'Country was successfully Updated.'
        format.html { redirect_to :controller => 'countries', :action => 'index'}
      else
        format.html { render action: "edit" }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @country = Country.find(params[:id])
    @country.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
  def action
    @ids = params[:chk]
    clength = @ids.length
    if params[:action_val] == "active"
      Country.update_all(["status = ? ", '0'],["id IN (?)", @ids])
      flash[:msg] = "#{clength} Record(s) Active sucessfully."
    end
    if params[:action_val] == "inactive"
      Country.update_all(["status = ? ", '1'],["id IN (?)", @ids] )
      flash[:msg] = "#{clength} Record(s) InActive sucessfully."
    end
    if params[:action_val] == "delete"
     @countries =  Country.find(:all, :conditions => ["id in (?)", @ids])
     @countries.each do |country|
       country.destroy
     end
     flash[:msg] = "#{clength} Record(s) Delete sucessfully."
    end
    redirect_to :controller => 'countries', :action => 'index'
    #format.html { redirect_to :controller => 'customers', :action => 'index' }
  end

end
