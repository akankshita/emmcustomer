  require 'rubygems'
  require 'rufus/scheduler'
  require 'open-uri'
  require 'csv'
scheduler = Rufus::Scheduler.start_new
=begin
#scheduler.every("1h") do
#    UserMailer.testing().deliver
#end

scheduler.cron("1 * * * *") do
    UserMailer.testing().deliver
end

#scheduler.at("18:02") do
#    UserMailer.testing().deliver
#end

#scheduler.join

scheduler.in '2m' do
    UserMailer.testing().deliver
end
=end
=begin
  scheduler.every '8h' do
    #puts "cron run#{Time.now}"
              ActiveRecord::Base.establish_connection(
                :adapter  => "postgresql",
                :host     => "ec2-54-243-238-144.compute-1.amazonaws.com",#"ec2-54-243-238-144.compute-1.amazonaws.com",
                :username => "mbqnxvumycnhxs",#izqcdmliwozmgx",
                :port => 5432,
                :password =>"lC_HYsKxXsJerxoLpR_a5sMAwg", #"35JS51QKt5gQHm2HOH2D97p7kZ",
                :database => "d89hd8fvckog43"#"d5v3qoof2vr5rs"
              )
              UserMailer.atest().deliver
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
            CSV.foreach("test.csv", {:headers => true, :header_converters => :symbol}) do |row|
              @all_arr = row[0].split(';')
              graph_data = {}
              graph_data['csvinfo_id'] = @csvinfo.id
              graph_data['meter_ip'] = "1.1.1.1"#@all_arr[0]
              graph_data['meter_id'] = @all_arr[5]
              graph_data['usuage_value'] = @all_arr[1]
              graph_data['start_time'] = @all_arr[6]
              graph_data['end_time'] = @all_arr[2]
              graph_data['kwh'] = "100"#@all_arr[5]
              @meter_reading = MeterReading.new(graph_data)
              @meter_reading.save
              # UserMailer.atest().deliver
              ActiveRecord::Base.establish_connection(
                :adapter  => "postgresql",
                :host     => "#{customer.db_host}",#"ec2-54-243-238-144.compute-1.amazonaws.com",
                :username => "#{customer.db_username}",#izqcdmliwozmgx",
                :port => customer.db_port,
                :password =>"#{customer.db_password}", #"35JS51QKt5gQHm2HOH2D97p7kZ",
                :database => "#{customer.db_name}"#"d5v3qoof2vr5rs"
              )
=begin              egraph_data = {}
              egraph_data['electricity_upload_id'] = @all_arr[0]
              egraph_data['electricity_value'] = @all_arr[1]
              egraph_data['end_time'] = @all_arr[2]
              egraph_data['meter_id'] = @all_arr[5]
              egraph_data['start_time'] = @all_arr[6]
              egraph_data['mid_time'] = @all_arr[7]
              egraph_data['user_id'] = @all_arr[8]
              #@electricity_reading = ElectricityReading.new(egraph_data)
              @electricity_reading = ElectricityReading.new
              @electricity_reading['electricity_upload_id'] = @all_arr[0]
              @electricity_reading['electricity_value'] = @all_arr[1]
              @electricity_reading['end_time'] = @all_arr[2]
              @electricity_reading['meter_id'] = @all_arr[5]
              @electricity_reading['start_time'] = @all_arr[6]
              @electricity_reading['mid_time'] = @all_arr[7]
              @electricity_reading ['user_id'] = 3#@all_arr[8]
              @electricity_reading.save
                ActiveRecord::Base.establish_connection(
                :adapter  => "postgresql",
                :host     => "ec2-54-243-238-144.compute-1.amazonaws.com",#"ec2-54-243-238-144.compute-1.amazonaws.com",
                :username => "mbqnxvumycnhxs",#izqcdmliwozmgx",
                :port => 5432,
                :password =>"lC_HYsKxXsJerxoLpR_a5sMAwg", #"35JS51QKt5gQHm2HOH2D97p7kZ",
                :database => "d89hd8fvckog43"#"d5v3qoof2vr5rs"
              ) 
            end
          end
        end
        
      end
     
    end

    UserMailer.testing().deliver
    
    
  end

=end              
  
#scheduler.every "1d" do
#    UserMailer.atest().deliver
#end
#24jan
scheduler.every '8h' do
    ActiveRecord::Base.establish_connection(
        :adapter  => "postgresql",
        :host     => "ec2-54-243-238-144.compute-1.amazonaws.com",#"ec2-54-243-238-144.compute-1.amazonaws.com",
        :username => "mbqnxvumycnhxs",#izqcdmliwozmgx",
        :port => 5432,
        :password =>"lC_HYsKxXsJerxoLpR_a5sMAwg", #"35JS51QKt5gQHm2HOH2D97p7kZ",
        :database => "d89hd8fvckog43"#"d5v3qoof2vr5rs"
    )
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
#    insert_to_customer_panel
#    ActiveRecord::Base.establish_connection("development")
    $tdate = Time.now.strftime("%Y-%m-%d")
    $nextdate = Time.now + 1.day
    $ndate = $nextdate.strftime("%Y-%m-%d")
    @all_data_today = MeterReading.find(:all,:conditions=>["created_at > ? and created_at < ?",$tdate,$ndate])
    @all_customer = Customer.all(:order=> "customer_id asc")
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

    ActiveRecord::Base.establish_connection("development")
    @all_customer.each do |customer|
      @cid = customer.customer_id
      @all_customer_data_today = MeterReading.find(:all,:conditions=>["created_at > ? and created_at < ? and customer_id = ?",$tdate,$ndate,@cid],:order=> "created_at asc")
      @start_time  = ""
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
                  :host     => "#{customer.db_host}",
                  :username => "#{customer.db_username}",
                  :port => customer.db_port,
                  :password =>"#{customer.db_password}", 
                  :database => "#{customer.db_name}"
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

    
end
