class XTeamSchedule::AssignmentGroup < ActiveRecord::Base
  belongs_to :schedule
  has_many :assignments, :dependent => :destroy

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :schedule_id
end
