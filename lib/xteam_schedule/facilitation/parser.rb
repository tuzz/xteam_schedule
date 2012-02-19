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
          :kind => a['kind']
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
  
  def parse_date(date_string)
    month, day, year = date_string.split('/').map(&:to_i)
    Date.new(year, month, day)
  end
end
