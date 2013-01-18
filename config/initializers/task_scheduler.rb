scheduler = Rufus::Scheduler.start_new

scheduler.every("1m") do
    UserMailer.testing().deliver
end

#scheduler.cron("30 17 * * *") do
#    UserMailer.testing().deliver
#end 