class XTeamSchedule::ResourceGroup < ActiveRecord::Base
  has_many :resources, :dependent => :destroy
  
  validates :name, :presence => true,
                   :uniqueness => true
end
