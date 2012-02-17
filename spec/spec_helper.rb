require 'rspec'
require 'factory_girl'
require 'database_cleaner'
require 'xteam_schedule'

RSpec.configure do |config|

  config.before(:suite) do
    FactoryGirl.find_definitions
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end