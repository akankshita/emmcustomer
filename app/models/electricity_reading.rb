#require 'time_utils'

class ElectricityReading < ActiveRecord::Base
  attr_accessible :meter_id,:start_time,:end_time,:mid_time,:electricity_upload_id,:user_id,:electricity_value
  
end
