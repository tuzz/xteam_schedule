class XTeamSchedule::WorkingTime < ActiveRecord::Base
  belongs_to :resource
  
  validates_presence_of :begin_date, :duration
end
