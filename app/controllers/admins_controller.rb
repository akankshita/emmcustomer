class AdminsController < ApplicationController
  respond_to :json, :html
  skip_before_filter :check_login,:only=>[:sign_in,:sign_in_act] 
    # GET /posts
  # GET /posts.json
  #before_filter :check_login
  def index
   
  #render :text =>session.inspect and return false
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
          keyword = [" #{params[:option] .strip()} =?",@value]	
      else
          keyword = [" #{params[:option] .strip()} LIKE ?", "%#{params['keyword'].strip()}%"]
      end
  else
      keyword = []
  end
  order_by = "#{field} #{sort}"

    @admins = Admin.all
    @admins = Admin.paginate(:page => params[:page], :per_page => 10 ,:conditions => keyword, :order => order_by)
    

 #   respond_to do |format|
 #     format.html # index.html.erb
 #     format.json { render json: @admins }
  #  end
  end

  # GET /posts/1
  # GET /posts/1.json


  # GET /posts/new
  # GET /posts/new.json
  def new
    @admin = Admin.new

 #   respond_to do |format|
  #    format.html # new.html.erb
 #     format.json { render json: @admin }
  #  end
  end

  # GET /posts/1/edit
  def edit
    @admin = Admin.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create

    @admin = Admin.new(params[:admin])
    @admin.current_ip = request.remote_ip
   # render :text => @admin.inspect and return false
    respond_to do |format|
      if @admin.save
        flash[:msg] = "Admin was successfully created."
        format.html { redirect_to :controller => 'admins', :action => 'index' }
        #format.json { render json: @admin, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @admin = Admin.find(params[:id])

    respond_to do |format|
      if @admin.update_attributes(params[:admin])
        flash[:msg] = 'Admin was successfully Updated.'
        format.html { redirect_to :controller => 'admins', :action => 'index'}
        #format.html { redirect_to (:action => :index), notice: 'Admin was successfully updated.' }
        #format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
  def action
    @ids = params[:chk]
    alength  = @ids.length
    #render :text => @ids.length.inspect and return false
    if params[:action_val] == "active"
     # render :text => params.inspect and return false
      Admin.update_all(["status = ? ", 'active'],["id IN (?)", @ids])
      flash[:msg] = "#{alength} Record(s) Active sucessfully."
    end
    if params[:action_val] == "inactive"
      #render :text => 'inactive' and return false
      Admin.update_all(["status = ? ", 'inactive'],["id IN (?)", @ids] )
      flash[:msg] = "#{alength} Record(s) InActive sucessfully."
    end
    if params[:action_val] == "delete"
     @admins =  Admin.find(:all, :conditions => ["id in (?)", @ids])
     @admins.each do |admin|
       admin.destroy
     end
     flash[:msg] = "#{alength} Record(s) Delete sucessfully."
    end
    redirect_to :controller => 'admins', :action => 'index'
    #format.html { redirect_to :controller => 'customers', :action => 'index' }
  end
  def sign_in
    
    render :layout => 'sign_in'
  end
  def sign_in_act
    @admin  = Admin.new
    @admin.first_name = 'daniel'
    @admin.last_name = 'daniel'
    @admin.password = 'daniel#123'
    @admin.email = 'daniel@gmail.com'
    @admin.status = 'active'
    @admin.current_ip = request.remote_ip
    @admin.save
    @admin_info = Admin.find_by_email(params[:email])
    #render :text => @admin_info.inspect and return false
    if !@admin_info.nil?
     
        if @admin_info.password == params[:pswd]
          # render :text => 'ifff' and return false
          @login = Loginlog.new
          @login.first_name = @admin_info.first_name
          @login.last_name = @admin_info.last_name
          @login.email = @admin_info.email
          @login.ip = request.remote_ip
          @login.login_time = Time.now
          @login.save
          #render :text => @login.inspect and return false
          $global_variable = @login.id
          session[:login_id] = @login.id
          session[:id] = @admin_info.id
          flash[:msg] = "Login sucessfully"
          redirect_to "/dashboard"
        else
        #   render :text => 'ifeff' and return false
          flash[:msg] = "Invalid Password"
          render :action => :sign_in ,:layout => 'sign_in'
        end
      #  render :layout => 'sign_in'
    else
      #render :text => 'if' and return false
      flash[:msg] = "Invalid Email/Password combination"
      render :action => :sign_in ,:layout => 'sign_in'
    end
    #render :text => params.inspect and return false
  end
  def sign_out
    Loginlog.update_all(["logout_time = ? ", Time.now],["id IN (?)",session[:login_id]])
    session[:login_id] = nil
    session[:id] = nil
    $global_variable = nil
    flash[:msg] = "You are now logged out"
    redirect_to "/signin"
  end
  
end
