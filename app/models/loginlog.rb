class Loginlog < ActiveRecord::Base
   attr_accessible :name, :email,:login_time,:logout_time,:ip
end
