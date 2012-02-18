class XTeamSchedule::Assignment < ActiveRecord::Base
  belongs_to :assignment_group
  has_many :working_times, :dependent => :destroy
  
  validates :name, :presence => true,
                   :uniqueness => true
end
