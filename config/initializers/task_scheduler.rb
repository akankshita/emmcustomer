scheduler = Rufus::Scheduler.start_new

#scheduler.every("1h") do
#    UserMailer.testing().deliver
#end

scheduler.cron("2 * * * *") do
    UserMailer.testing().deliver
end 