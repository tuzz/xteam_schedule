FactoryGirl.define do
  
  factory :schedule, :class => XTeamSchedule::Schedule do
  end
  
  factory :interface, :class => XTeamSchedule::Interface do
  end
  
  factory :weekly_working_schedule, :class => XTeamSchedule::WeeklyWorkingSchedule do
  end
  
  factory :working_day, :class => XTeamSchedule::WorkingDay do
  end
  
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
  
  factory :working_time, :class => XTeamSchedule::WorkingTime do
    sequence(:begin_date) { |n| Date.new(2000, n, 01) }
    duration 10
  end
  
end
