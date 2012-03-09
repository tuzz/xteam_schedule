class XTeamSchedule::Schedule < ActiveRecord::Base
  has_many :resource_groups, :dependent => :destroy
  has_many :resources, :through => :resource_groups
  has_many :assignment_groups, :dependent => :destroy
  has_many :assignments, :through => :assignment_groups
  has_many :working_days, :through => :weekly_working_schedule
  
  has_one :interface
  has_one :weekly_working_schedule
  
  after_initialize :set_default_interface
  after_initialize :set_default_weekly_working_schedule
  def after_initialize
    set_default_interface
    set_default_weekly_working_schedule
  end
  
  def working_times
    XTeamSchedule::WorkingTime.find_by_sql([
    "select distinct * from working_times as wt
     join resources r on wt.resource_id = r.id
     join resource_groups rg on r.resource_group_id = rg.id
     where rg.schedule_id = ?", id
    ])
  end
  
private
  
  def set_default_interface
    self.interface ||= XTeamSchedule::Interface.new
  end
  
  def set_default_weekly_working_schedule
    self.weekly_working_schedule = XTeamSchedule::WeeklyWorkingSchedule.new
  end
  
end
