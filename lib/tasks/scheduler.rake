task :cron => :environment do
until Time.now.hour == 14 && Time.now.min == 20
  UserMailer.testing().deliver
end

end