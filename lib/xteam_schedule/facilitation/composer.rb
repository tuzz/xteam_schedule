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
    compose_assignments!
    compose_working_times!
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
        'image' => (StringIO.new(r.image) if r.image),
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
  
  def compose_assignments!
    hash['tasks'] ||= []
    assignments = schedule.assignment_groups.map(&:assignments).flatten
    assignments.each do |a|
      hash['tasks'] << {
        'name' => a.name
      }
    end
  end
  
  def compose_working_times!
    hash['objectsForResources'] ||= {}
    resources = schedule.resource_groups.map(&:resources).flatten
    resources.each do |r|
      working_times_with_parents = r.working_times.select { |wt| wt.resource and wt.assignment }
      next unless working_times_with_parents
      hash['objectsForResources'].merge!(r.name => [])
      working_times_with_parents.each do |wt|
        hash['objectsForResources'][r.name] << {
          'task' => wt.assignment.name,
          'begin date' => compose_date(wt.begin_date),
          'duration' => wt.duration,
          'notes' => wt.notes
        }
      end
    end
  end
  
  def compose_date(date)
    components = []
    components << ("%02d" % date.month)
    components << ("%02d" % date.day)
    components << date.year
    components.join('/')
  end
end
