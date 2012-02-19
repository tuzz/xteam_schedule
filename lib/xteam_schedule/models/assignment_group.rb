class XTeamSchedule::AssignmentGroup < ActiveRecord::Base
  belongs_to :schedule
  has_many :assignments, :dependent => :destroy
  
  validates :name, :presence => true,
                   :uniqueness => true
  validates_presence_of :kind
end
