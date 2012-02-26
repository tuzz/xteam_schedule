class XTeamSchedule::Composer
  
  attr_accessor :schedule, :hash
  
  def self.compose(schedule)
    new(schedule).compose
  end
  
  def initialize(schedule)
    schedule.save!
    self.schedule = schedule
    self.hash = {}
  end
  
  def compose
    compose_resource_groups!
    compose_resources!
    compose_assignment_groups!
    compose_assignments!
    compose_working_times!
    compose_interface!
    compose_weekly_working_schedule!
    compose_schedule!
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
        'phone' => r.phone,
        'group' => r.resource_group.name
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
        'name' => a.name,
        'category' => a.assignment_group.name,
        'kind' => 0,
        'color' => compose_colour(a.colour)
      }
    end
  end
  
  def compose_working_times!
    hash['objectsForResources'] ||= {}
    resources = schedule.resource_groups.map(&:resources).flatten
    resources.each do |r|
      working_times_with_parents = r.working_times.select { |wt| wt.resource and wt.assignment }
      next unless working_times_with_parents.any?
      hash['objectsForResources'].merge!(r.name => [])
      working_times_with_parents.each do |wt|
        hash['objectsForResources'][r.name] << {
          'task' => wt.assignment.name,
          'begin date' => compose_date(wt.begin_date),
          'duration' => wt.duration,
          'notes' => wt.notes,
          'title' => ''
        }
      end
    end
  end
  
  def compose_interface!
    interface = schedule.interface
    hash['display task names'] = interface.display_assignments_name
    hash['display resource names'] = interface.display_resources_name
    hash['display worked time'] = interface.display_working_hours
    hash['display resource icons'] = interface.display_resources_pictures
    hash['display resource totals'] = interface.display_total_of_working_hours
    hash['display task notes'] = interface.display_assignments_notes
    hash['display absence cells'] = interface.display_absences
    hash['interface status'] = { 'latest time navigation mode' => interface.time_granularity }
  end
  
  def compose_weekly_working_schedule!
    weekly_working_schedule = schedule.weekly_working_schedule
    working_days = weekly_working_schedule.working_days
    
    hash['settings'] ||= {}
    hash['settings']['working schedule'] ||= {}
    
    working_days.each do |day|
      day_name = day.name.downcase
      hash['settings']['working schedule'][day_name] =
      if day.day_begin.present?
        { 'worked' => 'yes',
          'begin' => compose_time(day.day_begin),
          'end' => compose_time(day.day_end) }
      else
        { 'worked' => 'no' }
      end
      
      hash['settings']['working schedule']["pause_#{day_name}"] =
      if day.day_begin.present? and day.break_begin.present?
        { 'worked' => 'yes',
          'begin' => compose_time(day.break_begin),
          'end' => compose_time(day.break_end),
          'duration' => compose_time(day.break_end) - compose_time(day.break_begin) }
      else
        { 'worked' => 'no' }
      end
    end
  end
  
  def compose_schedule!
    hash['begin date'] = compose_date(schedule.begin_date)
    hash['end date'] = compose_date(schedule.end_date)
  end
  
  def compose_colour(colour_hash)
    { 'alpha' => 1 }.merge([:red, :green, :blue].inject({}) { |h, c| h[c.to_s] = colour_hash[c]; h })
  end
  
  def compose_date(date)
    return unless date.present?
    components = []
    components << ("%02d" % date.month)
    components << ("%02d" % date.day)
    components << date.year
    components.join('/')
  end
  
  def compose_time(time_string)
    return unless time_string.present?
    hours, minutes = time_string.split(':').map(&:to_i)
    
    hours * 60 + minutes
  end
end
