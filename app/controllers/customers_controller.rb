class CustomersController < ApplicationController
    respond_to :json, :html
    # GET /posts
  # GET /posts.json
  def index
   # render :text => "hi" and return false
    #@customers = Customer.all
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
    
    @customers = Customer.paginate(:page => params[:page], :per_page => 10,:conditions => keyword, :order => order_by)

 #   respond_to do |format|
 #     format.html # index.html.erb
 #     format.json { render json: @customers }
  #  end
  end

  # GET /posts/1
  # GET /posts/1.json


  # GET /posts/new
  # GET /posts/new.json
  def new
    @customer = Customer.new

 #   respond_to do |format|
  #    format.html # new.html.erb
 #     format.json { render json: @customer }
  #  end
  end

  # GET /posts/1/edit
  def edit
    @customer = Customer.find(params[:id])
    @csvinfos = Csvinfo.paginate(:page => params[:page], :per_page => 10,:conditions => ['customer_id =?', @customer.id])
   
    #@csvinfos = Csvinfo.find(:all,:conditions =>['customer_id =?', @customer.id])
    #render :text => @csvinfos.inspect and return false
  end

  # POST /posts
  # POST /posts.json
  def create
    #render :text => params.inspect and return false
    params[:customer][:country] = params[:country]
    params[:customer][:status] = params[:status]
    @customer = Customer.new(params[:customer])
  
   # render :text => @customer.inspect and return false
    respond_to do |format|
      if @customer.save
        flash[:msg] = 'Customer was successfully created.'
        format.html { redirect_to :controller => 'customers', :action => 'index' }
        #format.json { render json: @customer, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @customer = Customer.find(params[:id])
    @csvinfos = Csvinfo.paginate(:page => params[:page], :per_page => 10,:conditions => ['customer_id =?', @customer.id])
# render :text => @csvinfos.inspect and return false
    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        flash[:msg] = 'Customer was successfully Updated.'
        format.html { redirect_to :controller => 'customers', :action => 'index'}
        #format.html { redirect_to (:action => :index), notice: 'Customer was successfully updated.' }
        #format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
  def action
    @ids = params[:chk]
    clength = @ids.length
   # render :text => params.inspect and return false
    if params[:action_val] == "active"
     # render :text => params.inspect and return false
      Customer.update_all(["status = ? ", 'active'],["id IN (?)", @ids])
      flash[:msg] = "#{clength} Record(s) Active sucessfully."
    end
    if params[:action_val] == "inactive"
      #render :text => 'inactive' and return false
      Customer.update_all(["status = ? ", 'inactive'],["id IN (?)", @ids] )
      flash[:msg] = "#{clength} Record(s) InActive sucessfully."
    end
    if params[:action_val] == "delete"
     @cusomers =  Customer.find(:all, :conditions => ["id in (?)", @ids])
     @customers.each do |cusotmer|
       cusotmer.destroy
     end
     flash[:msg] = "#{clength} Record(s) Delete sucessfully."
    end
    redirect_to :controller => 'customers', :action => 'index'
    #format.html { redirect_to :controller => 'customers', :action => 'index' }
  end

end
