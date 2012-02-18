class XTeamSchedule::WorkingTime < ActiveRecord::Base
  belongs_to :resource
  belongs_to :assignment
  belongs_to :schedule
  
  validates_presence_of :begin_date, :duration
end
