class XTeamSchedule::Schedule < ActiveRecord::Base
  has_many :resource_groups, :dependent => :destroy
  has_many :resources, :through => :resource_groups
  has_many :assignment_groups, :dependent => :destroy
  has_many :working_times, :dependent => :destroy
end
