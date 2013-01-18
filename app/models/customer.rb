class Customer < ActiveRecord::Base
  attr_accessible :customer_id,:name,:email,:licence_id,:status,:city,:country,:postalcode,:phone,:phone_code,:heroku_url,:heroku_username,:heroku_password,:git_url,:amazon_url,:db_host,:db_name,:db_username,:db_password,:db_port
  belongs_to :csvinfo
  validates_presence_of :customer_id,:name,:email,:licence_id,:status,:city,:country,:postalcode,:phone,:phone_code,:heroku_url,:heroku_username,:git_url,:amazon_url,:db_host,:db_name,:db_username,:db_password,:db_port
  validates_presence_of :heroku_password,:on => :create
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => " Invalid Format"
  validates :email,:uniqueness => true,:on => :create
end
