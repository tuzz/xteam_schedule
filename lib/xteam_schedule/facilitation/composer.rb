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
    hash
  end
  
private
  
  def compose_resource_groups!
    hash['resource groups'] ||= []
    schedule.resource_groups.each do |rg|
      hash['resource groups'] << {
        'name' => rg.name,
        'expanded in library' => rg.expanded_in_library
      }
    end
  end
  
  # def parse_resource_groups!
  #   hash['resource groups'].try(:each) do |rg|
  #     schedule.resource_groups.create!(
  #       :name => rg['name'],
  #       :expanded_in_library => rg['expanded in library']
  #     )
  #   end
  # end
  
end
