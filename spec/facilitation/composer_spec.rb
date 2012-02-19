require 'spec_helper'

describe XTeamSchedule::Composer do
  
  describe '.compose' do
    it 'returns a hash' do
      XTeamSchedule::Composer.compose({}).should be_a Hash
    end
  end
  
  describe '#initialize' do
    it 'sets the schedule and hash instance variables' do
      schedule = XTeamSchedule::Schedule.new
      composer = XTeamSchedule::Composer.new(schedule)
      composer.schedule.should == schedule
      composer.hash.should_not be_nil
    end
  end
  
  describe '#compose' do
    before do
      schedule = XTeamSchedule::Schedule.new
      @composer = XTeamSchedule::Composer.new(schedule)
    end
    
    it 'returns a hash' do
      @composer.compose.should be_a Hash
    end
  end
  
end
