require 'spec_helper'

describe XTeamSchedule::Composer do
  
  describe '.compose' do
    it 'returns a hash' do
      schedule = XTeamSchedule::Schedule.new
      XTeamSchedule::Composer.compose(schedule).should be_a Hash
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
    
    it 'calls compose_resource_groups!' do
      @composer.should_receive(:compose_resource_groups!)
      @composer.compose
    end
  end
  
  describe '#compose_resource_groups!' do
    before do
      @schedule = XTeamSchedule::Schedule.new
      @schedule.resource_groups.new(:name => 'foo', :expanded_in_library => true)
      @schedule.resource_groups.new(:name => 'bar', :expanded_in_library => false)
      @composer = XTeamSchedule::Composer.new(@schedule)
    end
    
    it 'creates resource groups' do
      @composer.send(:compose_resource_groups!)
      @composer.hash['resource groups'].count.should_not be_zero
    end
    
    it 'sets the name key correctly' do
      @composer.send(:compose_resource_groups!)
      @composer.hash['resource groups'][0]['name'].should == 'foo'
      @composer.hash['resource groups'][1]['name'].should == 'bar'
    end
    
    it 'sets the expanded in library key correctly' do
      @composer.send(:compose_resource_groups!)
      @composer.hash['resource groups'][0]['expanded in library'].should be_true
      @composer.hash['resource groups'][1]['expanded in library'].should be_false
    end
  end
end
