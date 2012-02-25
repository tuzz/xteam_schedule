class XTeamSchedule::WorkingDay < ActiveRecord::Base
  belongs_to :weekly_working_schedule
  
  validate :format_of_times
  
  WORKING_DAY_NAMES = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
  
private
  
  def format_of_times
    time_format = /\d{2}:\d{2}/
    [:day_begin, :day_end, :break_begin, :break_end].each do |sym|
      time = send(sym)
      return if sym == :day_begin and time.nil?
      return if sym == :break_begin and time.nil?
      unless time =~ time_format
        errors.add(sym, 'is not a valid 24-hour time, must be hh:mm format')
        next
      end
      hours, minutes = time.split(':').map(&:to_i)
      if hours > 23 or minutes > 59
        errors.add(sym, 'is not a valid 24-hour time, must be hh:mm format')
      end
    end
  end
  
end
