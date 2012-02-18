class XTeamSchedule::AssignmentGroup < ActiveRecord::Base
  has_many :assignments, :dependent => :destroy
  
  validates :name, :presence => true,
                   :uniqueness => true
end
