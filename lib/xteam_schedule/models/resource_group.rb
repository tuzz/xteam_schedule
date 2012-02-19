class XTeamSchedule::ResourceGroup < ActiveRecord::Base
  belongs_to :schedule
  has_many :resources, :dependent => :destroy
  
  validates :name, :presence => true,
                   :uniqueness => true
  validates_presence_of :kind
end
