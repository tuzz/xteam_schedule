class XTeamSchedule::Resource < ActiveRecord::Base
  belongs_to :resource_group
  
  validates :name, :presence => true,
                   :uniqueness => true
end
