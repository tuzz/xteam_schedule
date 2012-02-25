class XTeamSchedule::Schedule < ActiveRecord::Base
  has_many :resource_groups, :dependent => :destroy
  has_many :resources, :through => :resource_groups
  has_many :assignment_groups, :dependent => :destroy
  has_many :assignments, :through => :assignment_groups
  has_many :working_times, :through => :resources
  
  has_one :interface
  after_initialize :set_default_interface
  
private
  
  def set_default_interface
    self.interface ||= XTeamSchedule::Interface.new
  end
  
end
