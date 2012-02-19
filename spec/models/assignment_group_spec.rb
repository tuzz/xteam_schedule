require 'spec_helper'

describe XTeamSchedule::AssignmentGroup do
  
  describe 'defaults' do
    it 'uses true for expanded_in_library' do
      XTeamSchedule::AssignmentGroup.new.expanded_in_library.should be_true
    end
    
    it 'uses 0 for kind' do
      XTeamSchedule::AssignmentGroup.new.kind.should == 0
    end
    
  end
  
  describe 'associations' do
    before do
      @assignment_group = Factory(:assignment_group)
    end
    
    it 'belongs to a schedule' do
      @assignment_group.schedule.should be_nil
      schedule = Factory(:schedule, :assignment_groups => [@assignment_group])
      @assignment_group.schedule.should == schedule
    end
    
    it 'has many assignments' do
      @assignment_group.assignments.should == []
      assignment = @assignment_group.assignments.create!(:name => 'foo')
      @assignment_group.assignments.count.should == 1
      @assignment_group.assignments.should == [assignment]
    end
    
    it 'destroys assignments on cascade' do
      @assignment_group.assignments.create!(:name => 'foo')
      @assignment_group.destroy
      XTeamSchedule::Assignment.count.should == 0
    end
  end
  
  describe 'validations' do
    before do
      @assignment_group = Factory(:assignment_group)
    end
    
    it 'requires a name' do
      @assignment_group.name = nil
      @assignment_group.should_not be_valid
    end
    
    it 'requires unique names' do
      duplicate = XTeamSchedule::AssignmentGroup.new(:name => @assignment_group.name)
      duplicate.should_not be_valid
    end
    
    it 'requires a kind' do
      @assignment_group.kind = nil
      @assignment_group.should_not be_valid
    end
  end
  
end
