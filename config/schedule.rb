# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
#require File.dirname(__FILE__) + "/application"
#require "/config/environment.rb"
require File.expand_path(File.dirname(__FILE__) + "/environment")
#env :PATH,'/home/tt-09/.rvm/rubies/ruby-1.9.3-p286/bin/ruby' 
set :output, "log/cron_log.log"
every 2.hours do
  runner "Admin.addadmin"
  #command "rm -rf #{Rails.root}/tmp/cache/assets/"
  #command "rm -rf #{Rails.root}/tmp/cache/assets/"
  #command "5 * * * * /usr/bin/wget -O - -q -t 1 http://localhost/cron.php"
  #Rails.logger.info Time.now.to_s
  #command "bundle exec rails runner -e production Admin.addadmin"
end

every 2.minutes do
  runner "Admin.addadmin"
end