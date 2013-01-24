class CreateMeterReadings < ActiveRecord::Migration
  def change
    create_table :meter_readings do |t|
      t.integer:csvinfo_id
      t.integer:meter_id
      t.string:meter_ip
      t.string:usuage_value
      t.datetime:start_time
      t.datetime:end_time
      t.string:kwh
      t.string:customer_id
      
      t.timestamps
    end
  end
end


