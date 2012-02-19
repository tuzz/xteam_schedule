class XTeamSchedule::WorkingTime < ActiveRecord::Base
  belongs_to :resource
  belongs_to :assignment
  delegate :resource_group, :to => :resource
  delegate :assignment_group, :to => :assignment
  delegate :schedule, :to => :resource
  
  validates_presence_of :begin_date, :duration
end
