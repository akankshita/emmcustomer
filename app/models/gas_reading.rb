#require 'time_utils'

class GasReading < ActiveRecord::Base
  attr_accessible :meter_id,:start_time,:end_time,:mid_time,:gas_upload_id,:user_id,:gas_value
  
end
