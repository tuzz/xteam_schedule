class XTeamSchedule::Schedule < ActiveRecord::Base
  has_many :resource_groups, :dependent => :destroy
  has_many :assignment_groups, :dependent => :destroy
end
