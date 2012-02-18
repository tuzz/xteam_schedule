class XTeamSchedule::Assignment < ActiveRecord::Base
  validates :name, :presence => true,
                   :uniqueness => true
end
