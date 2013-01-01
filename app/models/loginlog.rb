class Loginlog < ActiveRecord::Base
   attr_accessible :first_name,:last_name, :email,:login_time,:logout_time,:ip
end
