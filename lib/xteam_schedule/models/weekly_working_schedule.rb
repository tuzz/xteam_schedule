class XTeamSchedule::WeeklyWorkingSchedule < ActiveRecord::Base
  belongs_to :schedule
  has_many :working_days, :dependent => :destroy
  
  ActiveSupport::Deprecation.silence do
    after_initialize :set_default_working_days
    def after_initialize
      set_default_working_days
    end
  end
  
private
  
  def set_default_working_days
    return unless self.working_days.empty?
    day_names = XTeamSchedule::WorkingDay::WORKING_DAY_NAMES
    weekdays = day_names[0..4]
    day_names.each_with_index do |name, i|
      self.working_days << XTeamSchedule::WorkingDay.new(
        :name => name,
        :day_begin => (weekdays.shift.present? ? '09:00' : nil),
        :day_end => '17:00',
        :break_begin => '12:00',
        :break_end => '13:00'
      )  
    end
  end
  
end
