class XTeamSchedule::Parser
  
  attr_accessor :hash, :schedule
  
  def self.parse(hash)
    new(hash).parse
  end
  
  def initialize(hash)
    self.hash = hash
    self.schedule = XTeamSchedule::Schedule.create!
  end
  
  def parse
    # componentised parse methods
    schedule
  end
  
end
