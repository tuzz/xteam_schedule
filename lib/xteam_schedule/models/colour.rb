class XTeamSchedule::Colour < ActiveRecord::Base
  validates_presence_of :alpha, :red, :green, :blue
end
