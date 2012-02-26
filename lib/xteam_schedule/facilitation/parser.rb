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
    parse_resources!
    parse_assignment_groups!
    parse_assignments!
    parse_working_times!
    parse_interface!
    parse_weekly_working_schedule!
    parse_schedule!
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
  
  def parse_resources!
    hash['resources'].try(:each) do |r|
      resource_group = schedule.resource_groups.find_by_name(r['group'])
      if resource_group
        image = r['image'].class == StringIO ? r['image'].read : ''
        resource_group.resources.create!(
          :displayed_in_planning => r['displayedInPlanning'],
          :email => r['email'],
          :image => image,
          :mobile => r['mobile'],
          :name => r['name'],
          :phone => r['phone']
        )
      end
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
  
  def parse_assignments!
    hash['tasks'].try(:each) do |a|
      assignment_group = schedule.assignment_groups.find_by_name(a['category'])
      if assignment_group
        assignment_group.assignments.create!(
          :name => a['name'],
          :colour => parse_colour(a['color'])
        )
      end
    end
  end
  
  def parse_working_times!
    resources = schedule.resource_groups.map(&:resources).flatten
    assignments = schedule.assignment_groups.map(&:assignments).flatten
    hash['objectsForResources'] ||= {}
    hash['objectsForResources'].each do |r_name, wt_array|
      resource = resources.detect { |r| r.name == r_name }
      next unless resource
      wt_array.each do |wt|
        assignment = assignments.detect { |a| a.name == wt['task'] }
        next unless assignment
        resource.working_times.create!(
          :assignment => assignment,
          :begin_date => parse_date(wt['begin date']),
          :duration => wt['duration'],
          :notes => wt['notes']
        )
      end
    end
  end
  
  def parse_interface!
    interface_status = hash['interface status']
    time_granularity = interface_status['latest time navigation mode'] if interface_status.present?
    schedule.interface.update_attributes!(
      :display_assignments_name => hash['display task names'],
      :display_resources_name => hash['display resource names'],
      :display_working_hours => hash['display worked time'],
      :display_resources_pictures => hash['display resource icons'],
      :display_total_of_working_hours => hash['display resource totals'],
      :display_assignments_notes => hash['display task notes'],
      :display_absences => hash['display absence cells'],
      :time_granularity => time_granularity
    )
  end
  
  def parse_weekly_working_schedule!
    settings = hash['settings']
    return unless settings.present?
    working_schedule = settings['working schedule']
    return unless working_schedule.present?
    
    weekly_working_schedule = schedule.weekly_working_schedule
    working_days = weekly_working_schedule.working_days
    
    working_days.destroy_all
    XTeamSchedule::WorkingDay::WORKING_DAY_NAMES.each do |name|
      day = working_schedule[name.downcase]
      pause = working_schedule["pause_#{name.downcase}"]
      
      if day.present?
        day_begin = parse_time(day['begin']) if day['worked'] == 'yes'
        day_end = parse_time(day['end']) if day_begin
      end
      
      if pause.present?
        break_begin = parse_time(pause['begin']) if pause['worked'] == 'yes'
        break_end = parse_time(pause['end']) if break_begin
      end
      
      working_days << XTeamSchedule::WorkingDay.create!(
        :name => name,
        :day_begin => day_begin, :day_end => day_end,
        :break_begin => break_begin, :break_end => break_end
      )
    end
  end
  
  def parse_schedule!
    schedule.update_attributes!(
      :begin_date => parse_date(hash['begin date']),
      :end_date => parse_date(hash['end date'])
    )
  end
  
  def parse_colour(colour_data)
    [:red, :green, :blue].inject({}) { |h, c| h[c] = colour_data[c.to_s]; h }
  end
  
  def parse_date(date_string)
    return unless date_string.present?
    month, day, year = date_string.split('/').map(&:to_i)
    Date.new(year, month, day)
  end
  
  def parse_time(seconds)
    return unless seconds.present?
    hours = seconds / 60
    minutes = seconds % 60
    
    hours = "%02d" % hours
    minutes = "%02d" % minutes
    [hours, minutes].join(':')
  end
end
