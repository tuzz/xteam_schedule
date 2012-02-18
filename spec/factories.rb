FactoryGirl.define do
  
  factory :resource_group, :class => XTeamSchedule::ResourceGroup do
    sequence(:name) { |n| "Resource Group #{n}"}
  end
  
  factory :resource, :class => XTeamSchedule::Resource do
    sequence(:name) { |n| "Resource #{n}" }
  end
  
  factory :assignment_group, :class => XTeamSchedule::AssignmentGroup do
    sequence(:name) { |n| "Assignment Group #{n}"}
  end
  
  factory :assignment, :class => XTeamSchedule::Assignment do
    sequence(:name) { |n| "Assignment #{n}"}
  end
  
end
