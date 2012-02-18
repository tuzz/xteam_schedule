class XTeamSchedule::AssignmentGroup < ActiveRecord::Base
  validates :name, :presence => true,
                   :uniqueness => true
end
