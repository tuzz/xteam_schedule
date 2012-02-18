require 'spec_helper'

describe XTeamSchedule::Schedule do
  
  describe 'associations' do
    before do
      @schedule = Factory(:schedule)
    end
    
    it 'has many resource_groups' do
      @schedule.resource_groups.should == []
      resource_group = @schedule.resource_groups.create!(:name => 'foo')
      @schedule.resource_groups.size.should == 1
      @schedule.resource_groups.should == [resource_group]
    end
    
    it 'destroys resource_groups on cascade' do
      @schedule.resource_groups.create!(:name => 'foo')
      @schedule.destroy
      XTeamSchedule::ResourceGroup.count.should == 0
    end
    
    it 'has many assignment_groups' do
      @schedule.assignment_groups.should == []
      assignment_group = @schedule.assignment_groups.create!(:name => 'foo')
      @schedule.assignment_groups.size.should == 1
      @schedule.assignment_groups.should == [assignment_group]
    end
    
    it 'destroys assignment_groups on cascade' do
      @schedule.assignment_groups.create!(:name => 'foo')
      @schedule.destroy
      XTeamSchedule::ResourceGroup.count.should == 0
    end
    
    it 'has many working_times' do
      @schedule.working_times.should == []
      working_time = @schedule.working_times.create!(:begin_date => Date.new, :duration => 0)
      @schedule.working_times.size.should == 1
      @schedule.working_times.should == [working_time]
    end
    
    it 'destroys working_times on cascade' do
      @schedule.working_times.create!(:begin_date => Date.new, :duration => 0)
      @schedule.destroy
      XTeamSchedule::WorkingTime.count.should == 0
    end
  end
  
end
