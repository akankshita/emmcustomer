class Position < ActiveRecord::Base
   attr_accessible :title, :status
   validates_presence_of :title, :status
end
