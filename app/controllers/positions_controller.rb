class PositionsController < ApplicationController
    respond_to :json, :html
  def index
    if params[:state] == "1"
        @position = 0
        sort = "ASC"
    else
        @position = 1
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
    
    @positions = Position.paginate(:page => params[:page], :per_page => 10,:conditions => keyword, :order => order_by)
  end

  def new
    @position = Position.new
   # render :text=> @position.inspect and return false

  end

  def edit
    @position = Position.find(params[:id])
   # render :text=> @position.country.inspect and return false
  end

  def create
    @position = Position.new(params[:position])
  
    respond_to do |format|
      if @position.save
        flash[:msg] = 'Position was successfully created.'
        format.html { redirect_to :controller => 'positions', :action => 'index' }
      else
        format.html { render action: "new" }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @position = Position.find(params[:id])
    respond_to do |format|
      if @position.update_attributes(params[:position])
        flash[:msg] = 'Position was successfully Updated.'
        format.html { redirect_to :controller => 'positions', :action => 'index'}
      else
        format.html { render action: "edit" }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @position = Position.find(params[:id])
    @position.destroy

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
      Position.update_all(["status = ? ", '0'],["id IN (?)", @ids])
      flash[:msg] = "#{clength} Record(s) Active sucessfully."
    end
    if params[:action_val] == "inactive"
      Position.update_all(["status = ? ", '1'],["id IN (?)", @ids] )
      flash[:msg] = "#{clength} Record(s) InActive sucessfully."
    end
    if params[:action_val] == "delete"
     @positions =  Position.find(:all, :conditions => ["id in (?)", @ids])
     @positions.each do |country|
       country.destroy
     end
     flash[:msg] = "#{clength} Record(s) Delete sucessfully."
    end
    redirect_to :controller => 'positions', :action => 'index'
    #format.html { redirect_to :controller => 'customers', :action => 'index' }
  end

end
