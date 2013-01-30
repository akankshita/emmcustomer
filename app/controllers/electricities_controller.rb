class ElectricitiesController < ApplicationController
  require 'rubygems'
  require 'open-uri'
  require 'csv'
  skip_before_filter :check_login,:only=>[:import_csv,:test,:cron_test] 
  def index
=begin
    @asd = []
    @aka = [1,2,3,4,5]
    @aka.each do |aka|
      if aka < 4
         @asd << aka
      else
        break
      end
     
    end
 render :text => @asd.inspect and return false
=end
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
    @all_customer = Customer.all(:order=> "customer_id asc")
    
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
            CSV.foreach("test.csv", {:headers => true, :header_converters => :symbol, :converters => :all}) do |row|
              row = Hash[row.headers[0..-1].zip(row.fields[0..-1])]
              #render :text => row.inspect and return false
              graph_data = {}
              graph_data['csvinfo_id'] = @csvinfo.id
              graph_data['meter_ip'] = row[:meter_ip]#"1.1.1.1"#@all_arr[0]
              graph_data['meter_id'] = row[:meter_id]#@all_arr[5]
              graph_data['usuage_value'] = ""#@all_arr[1]
              graph_data['start_time'] = row[:start_time]#@all_arr[6]
              graph_data['end_time'] = row[:end_time]#@all_arr[2]
              graph_data['kwh'] = row[:kwh_equivalents]#"100"#@all_arr[5]
              graph_data['customer_id'] = @cid
              #render :text => graph_data.inspect and return false
              @meter_reading = MeterReading.new(graph_data)
              @meter_reading.save
            end
          end
        end
        
      end
     
    end

    UserMailer.testing().deliver
    insert_to_customer_panel
    
  end
  
  
  def insert_to_customer_panel
    ActiveRecord::Base.establish_connection("development")
    $tdate = Time.now.strftime("%Y-%m-%d")
    $nextdate = Time.now + 1.day
    $ndate = $nextdate.strftime("%Y-%m-%d")
    @all_data_today = MeterReading.find(:all,:conditions=>["created_at > ? and created_at < ?",$tdate,$ndate])
    @all_customer = Customer.all(:order=> "customer_id asc")
              ActiveRecord::Base.establish_connection(
                :adapter  => "postgresql",
                :host     => "localhost",#"ec2-54-243-238-144.compute-1.amazonaws.com",
                :username => "barringtonss",#izqcdmliwozmgx",
                #port => customer.db_port,
                :password =>"barringtonss", #"35JS51QKt5gQHm2HOH2D97p7kZ",
                :database => "customer1_development"#"d5v3qoof2vr5rs"
              )


    ActiveRecord::Base.establish_connection("development")
    @all_customer.each do |customer|

   
      @cid = customer.customer_id
      @all_customer_data_today = MeterReading.find(:all,:conditions=>["created_at > ? and created_at < ? and customer_id = ?",$tdate,$ndate,@cid],:order=> "created_at asc")
      @start_time  = ""
              ActiveRecord::Base.establish_connection(
                :adapter  => "postgresql",
                :host     => "localhost",#"ec2-54-243-238-144.compute-1.amazonaws.com",
                :username => "barringtonss",#izqcdmliwozmgx",
                #port => customer.db_port,
                :password =>"barringtonss", #"35JS51QKt5gQHm2HOH2D97p7kZ",
                :database => "customer1_development"#"d5v3qoof2vr5rs"
              )
    @emeter = []
    @gmeter = []
    @emeter_deatils = Meter.find(:all,:conditions => ["source_type_id = 1"])
    @emeter_deatils.each do |emeter_deatil|
      @emeter << emeter_deatil.meter_ip
    end
    @gmeter_deatils = Meter.find(:all,:conditions => ["source_type_id = 2"])
    @gmeter_deatils.each do |gmeter_deatil|
      @gmeter << gmeter_deatil.meter_ip
    end
      if !@all_customer_data_today.nil?
        @all_customer_data_today.each do |customer_data|
          #render :text => customer_data.end_time.inspect and return false
          if customer_data.meter_id == 1
            $time_diff = ((customer_data.end_time - customer_data.start_time)/60).round.to_i#((customer_data.start_time - customer_data.end_time) / 1.hours).round#time_diff(customer_data.start_time,customer_data.end_time)#(customer_data.start_time.minus_with_coercion(customer_data.end_time)/360).round#customer_data.end_time - customer_data.start_time
            #render :text =>$time_diff.inspect and return false
            if (@emeter.include?("#{customer_data.meter_ip}") == true) && (!customer_data.meter_ip.nil?) && ($time_diff == 30)
              #render :text => 'eif'.inspect and return false
              ActiveRecord::Base.establish_connection(
                :adapter  => "postgresql",
                :host     => "localhost",
                :username => "barringtonss",
                :password =>"barringtonss", 
                :database => "customer1_development"
              )
              @last_record_details = ElectricityReading.last
              #render :text =>  @last_record_details.inspect and return false
              $time_diff_last = ((customer_data.start_time - @last_record_details.start_time)/60).round.to_i if !@last_record_details.nil?
              if($time_diff_last == 30 || @last_record_details.nil?)
                @electricity_reading = ElectricityReading.new
                @electricity_reading['electricity_value'] = customer_data["kwh"]#@all_arr[1]
                @electricity_reading['end_time'] = customer_data["end_time"]#@all_arr[2]
                @electricity_reading['start_time'] = customer_data["start_time"]#@all_arr[6]
                @electricity_reading.save
              else
                ActiveRecord::Base.establish_connection("development")
                UserMailer.ipnotavaialable().deliver
                break
              end
            else
              #render :text => 'elsee'.inspect and return false
              ActiveRecord::Base.establish_connection("development")
              UserMailer.ipnotavaialable().deliver
              break
            end
          end
          if customer_data.meter_id == 2
            if (@gmeter.include?("#{customer_data.meter_ip}") == true) && (!customer_data.meter_ip.nil?) && ($time_diff == 30)
              ActiveRecord::Base.establish_connection(
                :adapter  => "postgresql",
                :host     => "localhost",
                :username => "barringtonss",
                :password =>"barringtonss", 
                :database => "customer1_development"
              )
              @last_record_details = GasReading.last
              $time_diff_last = ((customer_data.start_time - @last_record_details.start_time)/60).round.to_i
              if($time_diff_last == 30 ) 
                @gas_reading = GasReading.new
                @gas_reading['gas_value'] = customer_data["kwh"]
                @gas_reading['end_time'] = customer_data["end_time"]
                @gas_reading['start_time'] = customer_data["start_time"]
                @gas_reading.save
              else
                ActiveRecord::Base.establish_connection("development")
                UserMailer.ipnotavaialable().deliver
                break
              end
            else
              #render :text => 'else'.inspect and return false
              ActiveRecord::Base.establish_connection("development")
              UserMailer.ipnotavaialable().deliver
              break
            end
          end
          if customer_data.meter_id == 3
          end
          if customer_data.meter_id == 4
          end
        end

      end
    end    
    render :text => @all_data_today.inspect and return false
  end
  
  def cron_test
    
    
    ActiveRecord::Base.establish_connection(
        :adapter  => "postgresql",
        :host     => "ec2-54-243-238-144.compute-1.amazonaws.com",#"ec2-54-243-238-144.compute-1.amazonaws.com",
        :username => "mbqnxvumycnhxs",#izqcdmliwozmgx",
        :port => 5432,
        :password =>"lC_HYsKxXsJerxoLpR_a5sMAwg", #"35JS51QKt5gQHm2HOH2D97p7kZ",
        :database => "d89hd8fvckog43"#"d5v3qoof2vr5rs"
    )
    @all_customer = Customer.all(:order=> "customer_id asc")
  #  render :text => @all_customer.inspect and return false
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
            CSV.foreach("test.csv", {:headers => true, :header_converters => :symbol, :converters => :all}) do |row|
              row = Hash[row.headers[0..-1].zip(row.fields[0..-1])]
              #render :text => row.inspect and return false
              graph_data = {}
              graph_data['csvinfo_id'] = @csvinfo.id
              graph_data['meter_ip'] = row[:meter_ip]#"1.1.1.1"#@all_arr[0]
              graph_data['meter_id'] = row[:meter_id]#@all_arr[5]
              graph_data['usuage_value'] = ""#@all_arr[1]
              graph_data['start_time'] = row[:start_time]#@all_arr[6]
              graph_data['end_time'] = row[:end_time]#@all_arr[2]
              graph_data['kwh'] = row[:kwh_equivalents]#"100"#@all_arr[5]
              graph_data['customer_id'] = @cid
              #render :text => graph_data.inspect and return false
              @meter_reading = MeterReading.new(graph_data)
              @meter_reading.save
            end
          end
        end
        
      end
     
    end

    UserMailer.testing().deliver
#    insert_to_customer_panel
#    ActiveRecord::Base.establish_connection("development")
    $tdate = Time.now.strftime("%Y-%m-%d")
    $nextdate = Time.now + 1.day
    $ndate = $nextdate.strftime("%Y-%m-%d")
    @all_data_today = MeterReading.find(:all,:conditions=>["created_at > ? and created_at < ?",$tdate,$ndate])
    @all_customer = Customer.all(:order=> "customer_id asc")
=begin
    ActiveRecord::Base.establish_connection(
      :adapter  => "postgresql",
      :host     => "#{customer.db_host}",
      :username => "#{customer.db_username}",
      :port => customer.db_port,
      :password =>"#{customer.db_password}", 
      :database => "#{customer.db_name}"
    )
    @emeter = []
    @gmeter = []
    @emeter_deatils = Meter.find(:all,:conditions => ["source_type_id = 1"])
    @emeter_deatils.each do |emeter_deatil|
      @emeter << emeter_deatil.meter_ip
    end
    @gmeter_deatils = Meter.find(:all,:conditions => ["source_type_id = 2"])
    @gmeter_deatils.each do |gmeter_deatil|
      @gmeter << gmeter_deatil.meter_ip
    end
=end
    #ActiveRecord::Base.establish_connection("development")

    @all_customer.each do |customer|
    ActiveRecord::Base.establish_connection(
        :adapter  => "postgresql",
        :host     => "ec2-54-243-238-144.compute-1.amazonaws.com",#"ec2-54-243-238-144.compute-1.amazonaws.com",
        :username => "mbqnxvumycnhxs",#izqcdmliwozmgx",
        :port => 5432,
        :password =>"lC_HYsKxXsJerxoLpR_a5sMAwg", #"35JS51QKt5gQHm2HOH2D97p7kZ",
        :database => "d89hd8fvckog43"#"d5v3qoof2vr5rs"
    )
      @cid = customer.customer_id
      @all_customer_data_today = MeterReading.find(:all,:conditions=>["created_at > ? and created_at < ? and customer_id = ?",$tdate,$ndate,@cid],:order=> "created_at asc")
      @start_time  = ""
      ActiveRecord::Base.establish_connection(
        :adapter  => "postgresql",
        :host     => "#{customer.db_host}",
        :username => "#{customer.db_username}",
        :port => customer.db_port,
        :password =>"#{customer.db_password}", 
        :database => "#{customer.db_name}"
      )
      @emeter = []
      @gmeter = []
      @emeter_deatils = Meter.find(:all,:conditions => ["source_type_id = 2"])
      @emeter_deatils.each do |emeter_deatil|
      #  @emeter << emeter_deatil.meter_ip
      end
      @gmeter_deatils = Meter.find(:all,:conditions => ["source_type_id = 1"])
      @gmeter_deatils.each do |gmeter_deatil|
      #  @gmeter << gmeter_deatil.meter_ip
      end
      @emeter = ["192.168.1.1","192.168.1.2","192.168.1.3"]
      @gmeter = ["192.168.1.1","192.168.1.2","192.168.1.3"]

      if !@all_customer_data_today.nil?
        @all_customer_data_today.each do |customer_data|
          render :text => customer_data.customer_data.meter_ip.inspect and return false
          if customer_data.meter_id == 1
            $time_diff = ((customer_data.end_time - customer_data.start_time)/60).round.to_i#((customer_data.start_time - customer_data.end_time) / 1.hours).round#time_diff(customer_data.start_time,customer_data.end_time)#(customer_data.start_time.minus_with_coercion(customer_data.end_time)/360).round#customer_data.end_time - customer_data.start_time
            #render :text =>$time_diff.inspect and return false
            if (@emeter.include?("#{customer_data.meter_ip}") == true) && (!customer_data.meter_ip.nil?) 
              #render :text => 'eif'.inspect and return false
                ActiveRecord::Base.establish_connection(
                  :adapter  => "postgresql",
                  :host     => "#{customer.db_host}",
                  :username => "#{customer.db_username}",
                  :port => customer.db_port,
                  :password =>"#{customer.db_password}", 
                  :database => "#{customer.db_name}"
                )
              @last_record_details = ElectricityReading.last
              #render :text =>  @last_record_details.inspect and return false
              $time_diff_last = ((customer_data.start_time - @last_record_details.start_time)/60).round.to_i if !@last_record_details.nil?
              if($time_diff_last == 30 || @last_record_details.nil?)
                @electricity_reading = ElectricityReading.new
                @electricity_reading['electricity_value'] = customer_data["kwh"]#@all_arr[1]
                @electricity_reading['end_time'] = customer_data["end_time"]#@all_arr[2]
                @electricity_reading['start_time'] = customer_data["start_time"]#@all_arr[6]
                @electricity_reading.save
              else
                  ActiveRecord::Base.establish_connection(
                      :adapter  => "postgresql",
                      :host     => "ec2-54-243-238-144.compute-1.amazonaws.com",#"ec2-54-243-238-144.compute-1.amazonaws.com",
                      :username => "mbqnxvumycnhxs",#izqcdmliwozmgx",
                      :port => 5432,
                      :password =>"lC_HYsKxXsJerxoLpR_a5sMAwg", #"35JS51QKt5gQHm2HOH2D97p7kZ",
                      :database => "d89hd8fvckog43"#"d5v3qoof2vr5rs"
                  )

#                ActiveRecord::Base.establish_connection("development")
                UserMailer.incorrecttime().deliver
                break
              end
            else
              ActiveRecord::Base.establish_connection(
                  :adapter  => "postgresql",
                  :host     => "ec2-54-243-238-144.compute-1.amazonaws.com",#"ec2-54-243-238-144.compute-1.amazonaws.com",
                  :username => "mbqnxvumycnhxs",#izqcdmliwozmgx",
                  :port => 5432,
                  :password =>"lC_HYsKxXsJerxoLpR_a5sMAwg", #"35JS51QKt5gQHm2HOH2D97p7kZ",
                  :database => "d89hd8fvckog43"#"d5v3qoof2vr5rs"
              )
              #render :text => 'elsee'.inspect and return false
#              ActiveRecord::Base.establish_connection("development")
              UserMailer.ipnotavaialable().deliver
              break
            end
          end
          if customer_data.meter_id == 2
            if (@gmeter.include?("#{customer_data.meter_ip}") == true) && (!customer_data.meter_ip.nil?) 
                ActiveRecord::Base.establish_connection(
                  :adapter  => "postgresql",
                  :host     => "#{customer.db_host}",
                  :username => "#{customer.db_username}",
                  :port => customer.db_port,
                  :password =>"#{customer.db_password}", 
                  :database => "#{customer.db_name}"
                )
              @last_record_details = GasReading.last
              $time_diff_last = ((customer_data.start_time - @last_record_details.start_time)/60).round.to_i
              if($time_diff_last == 30 || @last_record_details.nil?) 
                @gas_reading = GasReading.new
                @gas_reading['gas_value'] = customer_data["kwh"]
                @gas_reading['end_time'] = customer_data["end_time"]
                @gas_reading['start_time'] = customer_data["start_time"]
                @gas_reading.save
              else
                ActiveRecord::Base.establish_connection(
                    :adapter  => "postgresql",
                    :host     => "ec2-54-243-238-144.compute-1.amazonaws.com",#"ec2-54-243-238-144.compute-1.amazonaws.com",
                    :username => "mbqnxvumycnhxs",#izqcdmliwozmgx",
                    :port => 5432,
                    :password =>"lC_HYsKxXsJerxoLpR_a5sMAwg", #"35JS51QKt5gQHm2HOH2D97p7kZ",
                    :database => "d89hd8fvckog43"#"d5v3qoof2vr5rs"
                )

#                ActiveRecord::Base.establish_connection("development")
                UserMailer.incorrecttime().deliver
                break
              end
            else
              ActiveRecord::Base.establish_connection(
                  :adapter  => "postgresql",
                  :host     => "ec2-54-243-238-144.compute-1.amazonaws.com",#"ec2-54-243-238-144.compute-1.amazonaws.com",
                  :username => "mbqnxvumycnhxs",#izqcdmliwozmgx",
                  :port => 5432,
                  :password =>"lC_HYsKxXsJerxoLpR_a5sMAwg", #"35JS51QKt5gQHm2HOH2D97p7kZ",
                  :database => "d89hd8fvckog43"#"d5v3qoof2vr5rs"
              )
              #render :text => 'else'.inspect and return false
#              ActiveRecord::Base.establish_connection("development")
              UserMailer.ipnotavaialable().deliver
              break
            end
          end
          if customer_data.meter_id == 3
          end
          if customer_data.meter_id == 4
          end
        end

      end
    end    
    ActiveRecord::Base.establish_connection(
        :adapter  => "postgresql",
        :host     => "ec2-54-243-238-144.compute-1.amazonaws.com",#"ec2-54-243-238-144.compute-1.amazonaws.com",
        :username => "mbqnxvumycnhxs",#izqcdmliwozmgx",
        :port => 5432,
        :password =>"lC_HYsKxXsJerxoLpR_a5sMAwg", #"35JS51QKt5gQHm2HOH2D97p7kZ",
        :database => "d89hd8fvckog43"#"d5v3qoof2vr5rs"
    )
    
    
  end
  
  def edit
    @electricities = MeterReading.paginate(:page => params[:page], :per_page => 10,:conditions => ["csvinfo_id = ?",params[:id]])
  end
  
  def test
    UserMailer.testing().deliver
  end
  
  
end
