class ElectricitiesController < ApplicationController
  require 'rubygems'
  require 'open-uri'
  require 'csv'
  skip_before_filter :check_login,:only=>[:import_csv] 
  def index
 # render :text => 'in' and return false
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
if params[:from] && params[:to]
  from = params[:from]
  to = params[:to]+' '+'23:30'
  keyword = [ "start_time >= ? AND end_time <= ?",from,to]
end
  order_by = "#{field} #{sort}"
  
  # render :text => keyword.inspect and return false
    
   # @electricities = Electricity.all
    @electricities = MeterReading.paginate(:page => params[:page], :per_page => 10,:conditions => keyword, :order => order_by)
  end
  
  def import_csv

    @all_customer = Customer.all
    
    @all_customer.each do |customer|
      @cid = customer.customer_id
      @csv_info = AWS::S3::Bucket.objects('emissionmanagement',:prefix => @cid )
      @csv_info[1..-1].each do |file|
        $tdate = Time.now.strftime("%d-%m-%Y")
        $fname = @cid +'/'+$tdate+'.csv'
        
        if file.key == $fname
          open('test.csv', 'w') do |newfile|
            AWS::S3::S3Object.stream($fname,'emissionmanagement') do |chunk|
              newfile.write chunk
            end
          end
          csvarray = CSV.read("test.csv")
          total_count = csvarray.length-1
          csvinfo= {}
          csvinfo['customer_id'] = customer.id
          csvinfo['name'] = $tdate+'.csv'
          csvinfo['verified'] = 'Yes'
          csvinfo['loaded'] = 'No'
          csvinfo['totaldata'] = total_count
          csvinfo['view'] = 'view'
          csvinfo['status'] = 'Invalid'
          csvinfo['upload_date'] = Time.now
          @csvinfo = Csvinfo.new(csvinfo)
          if @csvinfo.save
            CSV.foreach("test.csv", {:headers => true, :header_converters => :symbol}) do |row|
              @all_arr = row[0].split(';')
              graph_data = {}
              graph_data['csvinfo_id'] = @csvinfo.id
              graph_data['meter_ip'] = @all_arr[0]
              graph_data['meter_id'] = @all_arr[1]
              graph_data['usuage_value'] = @all_arr[2]
              graph_data['start_time'] = @all_arr[3]
              graph_data['end_time'] = @all_arr[4]
              graph_data['kwh'] = @all_arr[5]
              @meter_reading = MeterReading.new(graph_data)
              @meter_reading.save
            end
          end
        end
        
      end
     
    end
    UserMailer.testing().deliver
    
    
  end
  
  def edit
    @electricities = MeterReading.paginate(:page => params[:page], :per_page => 10,:conditions => ["csvinfo_id = ?",params[:id]])
  end
  
  
end
