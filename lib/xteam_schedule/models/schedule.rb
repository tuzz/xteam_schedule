class XTeamSchedule::Schedule < XTeamSchedule::Base
  has_many :resource_groups, :dependent => :destroy
  has_many :resources, :through => :resource_groups
  has_many :assignment_groups, :dependent => :destroy
  has_many :assignments, :through => :assignment_groups
  has_many :working_days, :through => :weekly_working_schedule
  has_many :holidays, :dependent => :destroy

  has_one :interface
  has_one :weekly_working_schedule
  has_one :remote_access

  ActiveSupport::Deprecation.silence do
    after_initialize :set_default_interface
    after_initialize :set_default_weekly_working_schedule
    after_initialize :set_default_remote_access
    def after_initialize
      set_default_interface
      set_default_weekly_working_schedule
      set_default_remote_access
    end
  end

  def working_times
    ids = resources.map(&:working_times).flatten.map(&:id)
    XTeamSchedule::WorkingTime.scoped(:conditions => { :id => ids })
  end

private

  def set_default_interface
    self.interface ||= XTeamSchedule::Interface.new
  end

  def set_default_weekly_working_schedule
    self.weekly_working_schedule ||= XTeamSchedule::WeeklyWorkingSchedule.new
  end

  def set_default_remote_access
    self.remote_access ||= XTeamSchedule::RemoteAccess.new
  end

end
