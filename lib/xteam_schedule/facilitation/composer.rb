class XTeamSchedule::Composer
  
  attr_accessor :schedule, :hash
  
  def self.compose(schedule)
    new(schedule).compose
  end
  
  def initialize(schedule)
    self.schedule = schedule
    self.hash = {}
  end
  
  def compose
    #componentised compose methods
    hash
  end
  
end
