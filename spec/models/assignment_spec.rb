require 'spec_helper'

describe XTeamSchedule::Assignment do
  
  describe 'associations' do
    before do
      @assignment = Factory(:assignment)
    end
    
    it 'belongs to a assignment group' do
      @assignment.assignment_group.should be_nil
      assignment_group = Factory(:assignment_group, :assignments => [@assignment])
      @assignment.assignment_group.should == assignment_group
    end
    
    it 'has many working_times' do
      @assignment.working_times.should == []
      working_time = @assignment.working_times.create!(:begin_date => Date.new, :duration => 0)
      @assignment.working_times.size.should == 1
      @assignment.working_times.should == [working_time]
    end
    
    it 'destroys working_times on cascade' do
      @assignment.working_times.create!(:begin_date => Date.new, :duration => 0)
      @assignment.destroy
      XTeamSchedule::WorkingTime.count.should == 0
    end
    
    it 'delegates schedule to assignment_group' do
      Factory(:assignment_group, :assignments => [@assignment])
      XTeamSchedule::AssignmentGroup.any_instance.should_receive(:schedule)
      @assignment.schedule
    end
  end
  
  describe 'validations' do
    before do
      @assignment = Factory(:assignment)
    end
    
    it 'requires a name' do
      @assignment.name = nil
      @assignment.should_not be_valid
    end
    
    it 'requires unique names' do
      duplicate = XTeamSchedule::Assignment.new(:name => @assignment.name)
      duplicate.should_not be_valid
    end
  end
  
end
