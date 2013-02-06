class Country < ActiveRecord::Base
   attr_accessible :name, :code, :description, :status
   validates_presence_of :name, :code, :description, :status
   has_many :states,:dependent => :destroy
end
