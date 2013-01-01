class MeterReading < ActiveRecord::Base
  attr_accessible :csvinfo_id, :meter_ip,:meter_id,:usuage_value,:start_time,:end_time,:kwh
  has_many :csvinfos,:dependent => :destroy
end
