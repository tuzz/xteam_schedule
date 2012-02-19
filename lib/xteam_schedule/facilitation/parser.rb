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
        string_io = r['image']
        resource_group.resources.create!(
          :displayed_in_planning => r['displayedInPlanning'],
          :email => r['email'],
          :image => string_io.try(:read),
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
          :name => a['name']
        )
      end
    end
  end
  
  def parse_working_times!
    hash['objectsForResources'].try(:each) do |wt_array|
      r_name = wt_array.first
      resource = schedule.resources.find_by_name(r_name)
      if resource
        wt = wt_array.second.first
        assignment = schedule.assignments.find_by_name(wt['task'])
        if assignment
          assignment.working_times.create!(
            :resource => resource,
            :begin_date => parse_date(wt['begin date']),
            :duration => wt['duration'],
            :notes => wt['notes']
          )
        end
      end
    end
  end
  
  def parse_date(date_string)
    month, day, year = date_string.split('/').map(&:to_i)
    Date.new(year, month, day)
  end
end
