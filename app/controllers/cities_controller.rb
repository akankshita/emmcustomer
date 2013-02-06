class CitiesController < ApplicationController
    respond_to :json, :html
  def index
    if params[:state] == "1"
        @city = 0
        sort = "ASC"
    else
        @city = 1
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
    
    @cities = City.paginate(:page => params[:page], :per_page => 10,:conditions => keyword, :order => order_by)
  end

  def new
    @city = City.new
   # render :text=> @city.inspect and return false

  end

  def edit
    @city = City.find(params[:id])
   # render :text=> @city.country.inspect and return false
  end

  def create
    @city = City.new(params[:city])
  
    respond_to do |format|
      if @city.save
        flash[:msg] = 'City was successfully created.'
        format.html { redirect_to :controller => 'cities', :action => 'index' }
      else
        format.html { render action: "new" }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @city = City.find(params[:id])
    respond_to do |format|
      if @city.update_attributes(params[:city])
        flash[:msg] = 'City was successfully Updated.'
        format.html { redirect_to :controller => 'cities', :action => 'index'}
      else
        format.html { render action: "edit" }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @city = City.find(params[:id])
    @city.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
  def action
   #   render :text=> params.inspect and return false
    @ids = params[:chk]
    clength = @ids.length
    if params[:action_val] == "active"
      City.update_all(["status = ? ", '0'],["id IN (?)", @ids])
      flash[:msg] = "#{clength} Record(s) Active sucessfully."
    end
    if params[:action_val] == "inactive"
      City.update_all(["status = ? ", '1'],["id IN (?)", @ids] )
      flash[:msg] = "#{clength} Record(s) InActive sucessfully."
    end
    if params[:action_val] == "delete"
     @cities =  City.find(:all, :conditions => ["id in (?)", @ids])
     @cities.each do |country|
       country.destroy
     end
     flash[:msg] = "#{clength} Record(s) Delete sucessfully."
    end
    redirect_to :controller => 'cities', :action => 'index'
    #format.html { redirect_to :controller => 'customers', :action => 'index' }
  end

end
