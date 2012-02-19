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
    compose_resource_groups!
    compose_resources!
    compose_assignment_groups!
    hash
  end
  
private
  
  def compose_resource_groups!
    hash['resource groups'] ||= []
    resource_groups = schedule.resource_groups
    resource_groups.each do |rg|
      hash['resource groups'] << {
        'name' => rg.name,
        'expanded in library' => rg.expanded_in_library
      }
    end
  end
  
  def compose_resources!
    hash['resources'] ||= []
    resources = schedule.resource_groups.map(&:resources).flatten
    resources.each do |r|
      hash['resources'] << {
        'displayedInPlanning' => r.displayed_in_planning,
        'email' => r.email,
        'image' => StringIO.new(r.image),
        'mobile' => r.mobile,
        'name' => r.name,
        'phone' => r.phone
      }
    end
  end
  
  def compose_assignment_groups!
    hash['task categories'] ||= []
    assignment_groups = schedule.assignment_groups
    assignment_groups.each do |ag|
      hash['task categories'] << {
        'name' => ag.name,
        'expanded in library' => ag.expanded_in_library
      }
    end
  end
end
