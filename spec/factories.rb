FactoryGirl.define do
  
  factory :resource_group, :class => XTeamSchedule::ResourceGroup do
    sequence(:name) { |n| "Product Group #{n}"}
  end
  
end
