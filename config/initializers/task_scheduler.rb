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

#  scheduler.every("45 12 * * *") do


#    UserMailer.testing().deliver
    
    
 # end
  
 scheduler.cron("20 30 * * *") do
    # do something
     UserMailer.testing().deliver
  end