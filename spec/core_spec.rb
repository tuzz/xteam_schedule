require 'spec_helper'

describe XTeamSchedule do
  
  describe '#initialize' do
    before do
      XTeamSchedule::IO.stub!(:read).and_return({ 'resource groups' => [
        { 'expandedInLibrary' => true, 'name' => 'foo'}
      ]})
    end
    
    it 'can be initialized with no parameters' do
      lambda {
        schedule = XTeamSchedule.new
        schedule.resource_groups.should be_empty
      }.should_not raise_error
    end
    
    it 'can be initialized by passing in a filename' do
      lambda {
        schedule = XTeamSchedule.new('path/to/file')
        schedule.resource_groups.should_not be_empty
      }.should_not raise_error
    end
  end
  
end