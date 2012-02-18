class XTeamSchedule::WorkingTime < ActiveRecord::Base
  validates_presence_of :begin_date, :duration
end
