class XTeamSchedule::WorkingDay < ActiveRecord::Base
  belongs_to :weekly_working_schedule
  
  WORKING_DAY_NAMES = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
end
