require 'rspec'
require 'factory_girl'
require 'xteam_schedule'

RSpec.configure do |config|

  config.before(:suite) do
    FactoryGirl.find_definitions
  end
  
  config.after(:each) do
    XTeamSchedule::Base.build_schema
  end

end
