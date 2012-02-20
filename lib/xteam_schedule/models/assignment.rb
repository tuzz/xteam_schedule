class XTeamSchedule::Assignment < ActiveRecord::Base
  belongs_to :assignment_group
  belongs_to :colour
  has_many :working_times, :dependent => :destroy
  delegate :schedule, :to => :assignment_group
  
  validates :name, :presence => true,
                   :uniqueness => true
  validates_presence_of :kind
end
