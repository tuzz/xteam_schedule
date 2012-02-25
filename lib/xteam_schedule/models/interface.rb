class XTeamSchedule::Interface < ActiveRecord::Base
  belongs_to :schedule
  
  alias_attribute :display_assignment_names, :display_assignments_name
  alias_attribute :display_resource_names, :display_resources_name
  alias_attribute :display_resource_pictures, :display_resources_pictures
  alias_attribute :display_total_working_hours, :display_total_of_working_hours
  alias_attribute :display_assignment_notes, :display_assignments_notes
  
  TIME_GRANULARITIES = { :day => 4, :week => 2, :month => 1, :year => 0 }
end
