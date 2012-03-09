class XTeamSchedule::Schedule < ActiveRecord::Base
  has_many :resource_groups, :dependent => :destroy
  has_many :resources, :through => :resource_groups
  has_many :assignment_groups, :dependent => :destroy
  has_many :assignments, :through => :assignment_groups
  has_many :working_times, :through => :resources
  has_many :working_days, :through => :weekly_working_schedule
  
  has_one :interface
  has_one :weekly_working_schedule
  
  def after_initialize
    set_default_interface
    set_default_weekly_working_schedule
  end
  
private
  
  def set_default_interface
    self.interface ||= XTeamSchedule::Interface.new
  end
  
  def set_default_weekly_working_schedule
    self.weekly_working_schedule = XTeamSchedule::WeeklyWorkingSchedule.new
  end
  
end
