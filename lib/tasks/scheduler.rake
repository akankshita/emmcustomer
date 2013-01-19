task :send_reminders => :environment do
until Time.now.hour == 0 && Time.now.min == 20
  UserMailer.testing().deliver
end

end