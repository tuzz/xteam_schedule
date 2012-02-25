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
end
