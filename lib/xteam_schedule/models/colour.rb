class XTeamSchedule::Colour < ActiveRecord::Base
  has_many :assignments
  
  validates_presence_of :alpha, :red, :green, :blue
end
