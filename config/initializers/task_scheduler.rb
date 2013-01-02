scheduler = Rufus::Scheduler.start_new

scheduler.every("1m") do
    UserMailer.testing().deliver
end 