  require 'rubygems'
  require 'rufus/scheduler'
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

  scheduler.cron '0 20 * * *' do
    #puts "cron run#{Time.now}"
    
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
              graph_data['meter_ip'] = "1.1.1.1"#@all_arr[0]
              graph_data['meter_id'] = @all_arr[5]
              graph_data['usuage_value'] = @all_arr[1]
              graph_data['start_time'] = @all_arr[6]
              graph_data['end_time'] = @all_arr[2]
              graph_data['kwh'] = "100"#@all_arr[5]
              @meter_reading = MeterReading.new(graph_data)
              @meter_reading.save
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
=end              
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
              ActiveRecord::Base.establish_connection('development')              
            end
          end
        end
        
      end
     
    end
    UserMailer.testing().deliver
    
    
  end