class XTeamSchedule::Resource < ActiveRecord::Base
  belongs_to :resource_group
  has_many :working_times, :dependent => :destroy
  delegate :schedule, :to => :resource_group
  
  validates :name, :presence => true,
                   :uniqueness => true
  validates_presence_of :kind
end
