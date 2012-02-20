class XTeamSchedule::Colour < ActiveRecord::Base
  validates_presence_of :red, :green, :blue
end
