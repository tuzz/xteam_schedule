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
    parse_resource_groups!
    parse_assignment_groups!
    schedule
  end
  
private
  
  def parse_resource_groups!
    hash['resource groups'].try(:each) do |rg|
      schedule.resource_groups.create!(
        :name => rg['name'],
        :expanded_in_library => rg['expanded in library']
      )
    end
  end
  
  def parse_assignment_groups!
    hash['task categories'].try(:each) do |ag|
      schedule.assignment_groups.create!(
        :name => ag['name'],
        :expanded_in_library => ag['expanded in library']
      )
    end
  end
  
end
