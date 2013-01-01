class LoginlogsController < ApplicationController
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
    #  elsif params[:option] == 'status'
# @value = (params["keyword"].downcase =="inactive" || params["keyword"].downcase =="active")? ((params["keyword"].downcase == "inactive")? 1 : 0) : -1
      #    keyword = [" #{params[:option] .strip()} =?",@value]	
      else
          keyword = [" #{params[:option] .strip()} LIKE ?", "%#{params['keyword'].strip()}%"]
      end
  else
      keyword = []
  end
  order_by = "#{field} #{sort}"
    
    #@loginlogs = Loginlog.all
   # @loginlogs = Loginlog.paginate(:page => params[:page], :per_page => 2,:conditions =>["id = ?",4])
    @loginlogs = Loginlog.paginate(:page => params[:page], :per_page => 10,:conditions => keyword, :order => order_by)
  end
  def action
    
    @ids = params[:chk]
    
    if params[:action_val] == "delete"
     @loginlogs =  Loginlog.find(:all, :conditions => ["id in (?)", @ids])
    # render :text => @loginlogs.inspect and return false
     @loginlogs.each do |loginlogs|
       loginlogs.destroy
     end
     flash[:msg] = "Records Delete sucessfully."
    end
    redirect_to :controller => 'loginlogs', :action => 'index'
    #format.html { redirect_to :controller => 'customers', :action => 'index' }
  end
end
