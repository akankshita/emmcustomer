class StatesController < ApplicationController
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
    
    @states = State.paginate(:page => params[:page], :per_page => 10,:conditions => keyword, :order => order_by)
  end

  def new
    @state = State.new
   # render :text=> @state.inspect and return false

  end

  def edit
    @state = State.find(params[:id])
   # render :text=> @state.country.inspect and return false
  end

  def create
    @state = State.new(params[:state])
  
    respond_to do |format|
      if @state.save
        flash[:msg] = 'State was successfully created.'
        format.html { redirect_to :controller => 'states', :action => 'index' }
      else
        format.html { render action: "new" }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @state = State.find(params[:id])
    respond_to do |format|
      if @state.update_attributes(params[:state])
        flash[:msg] = 'State was successfully Updated.'
        format.html { redirect_to :controller => 'states', :action => 'index'}
      else
        format.html { render action: "edit" }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @state = State.find(params[:id])
    @state.destroy

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
      State.update_all(["status = ? ", '0'],["id IN (?)", @ids])
      flash[:msg] = "#{clength} Record(s) Active sucessfully."
    end
    if params[:action_val] == "inactive"
      State.update_all(["status = ? ", '1'],["id IN (?)", @ids] )
      flash[:msg] = "#{clength} Record(s) InActive sucessfully."
    end
    if params[:action_val] == "delete"
     @states =  State.find(:all, :conditions => ["id in (?)", @ids])
     @states.each do |country|
       country.destroy
     end
     flash[:msg] = "#{clength} Record(s) Delete sucessfully."
    end
    redirect_to :controller => 'states', :action => 'index'
    #format.html { redirect_to :controller => 'customers', :action => 'index' }
  end

end
