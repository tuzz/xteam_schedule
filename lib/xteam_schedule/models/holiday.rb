class XTeamSchedule::Holiday < XTeamSchedule::Base
  belongs_to :schedule
  belongs_to :resource

  validates_presence_of :begin_date
end
