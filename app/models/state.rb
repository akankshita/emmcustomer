class State < ActiveRecord::Base
   attr_accessible :country_id, :name, :code, :description, :status
   validates_presence_of :country_id, :name, :code, :description, :status
   belongs_to :country
   has_many :cities
end
