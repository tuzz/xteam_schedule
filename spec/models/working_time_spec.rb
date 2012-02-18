require 'spec_helper'

describe XTeamSchedule::WorkingTime do
  
  describe 'associations' do
    before do
      @working_time = Factory(:working_time)
    end
    
    it 'belongs to a resource' do
      @working_time.resource.should be_nil
      resource = Factory(:resource, :working_times => [@working_time])
      @working_time.resource.should == resource
    end
    
    it 'belongs to an assignment' do
      @working_time.assignment.should be_nil
      assignment = Factory(:assignment, :working_times => [@working_time])
      @working_time.assignment.should == assignment
    end
  end
  
  describe 'validations' do
    before do
      @working_time = Factory(:working_time)
    end
    
    it 'requires a begin_date' do
      @working_time.begin_date = nil
      @working_time.should_not be_valid
    end
    
    it 'requires a duration' do
      @working_time.duration = nil
      @working_time.should_not be_valid
    end
  end
  
end
