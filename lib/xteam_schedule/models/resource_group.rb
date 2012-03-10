class XTeamSchedule::ResourceGroup < XTeamSchedule::Base
  belongs_to :schedule
  has_many :resources, :dependent => :destroy
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :schedule_id
end
