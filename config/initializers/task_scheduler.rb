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
=end
scheduler.in '2m' do
    UserMailer.testing().deliver
end