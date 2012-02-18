class XTeamSchedule::Assignment < ActiveRecord::Base
  belongs_to :assignment_group
  
  validates :name, :presence => true,
                   :uniqueness => true
end
