class XTeamSchedule::Resource < ActiveRecord::Base
  belongs_to :resource_group
  has_many :working_times, :dependent => :destroy
  
  validates :name, :presence => true,
                   :uniqueness => true
end
