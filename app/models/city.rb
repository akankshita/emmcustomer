class City < ActiveRecord::Base
   attr_accessible :state_id, :name, :code, :description, :status
   validates_presence_of :state_id, :name, :code, :description, :status
    belongs_to :state
end
