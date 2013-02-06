class Admin < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :first_name, :last_name, :email, :password, :status,:current_ip,:email2, :country_id, :state_id, :city_id, :zip_code, :phone, :phone1, :mobile
  validates_presence_of :first_name,:last_name,:email,:email2, :country_id, :state_id, :city_id, :zip_code, :phone, :phone1, :mobile
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => " Invalid Format"
  validates_format_of :email2, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => " Invalid Format"
  validates :email,:uniqueness => true,:on => :create
  validates_presence_of :password,:on => :create
  validates_length_of :password, :minimum => 6, :too_short => "needs minimun 6 character",:on => :create
  
   def self.cron_job
     # logger.info Time.now.to_s
      # puts "Just do it"
       logger.debug "Just do it"
   end
  
  def self.addadmin
    @admin = Admin.new
    @admin.first_name = 'test'
    @admin.last_name = 'test'
    @admin.email = 'aa@gmail.com'
    @admin.password = 'aaaaaa'
    @admin.status = 'active'
    @admin.current_ip='192.168.1.4'
    @admin.save
  end
  task :addadmin => :environment do
    @admin = Admin.new
    @admin.first_name = 'test'
    @admin.last_name = 'test'
    @admin.email = 'aa@gmail.com'
    @admin.password = 'aaaaaa'
    @admin.status = 'active'
    @admin.current_ip='192.168.1.4'
    @admin.save
  end
  
  
end
