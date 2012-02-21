require 'spec_helper'

describe XTeamSchedule::Assignment do
  
  describe 'defaults' do
    it 'uses 0 for kind' do
      XTeamSchedule::Assignment.new.kind.should be_zero
    end
    
    it "uses '0.5,0.5,0.5,1' for colour" do
      XTeamSchedule::Assignment.new[:colour].should == '0.5,0.5,0.5,1'
    end
  end
  
  describe 'associations' do
    before do
      @assignment = Factory(:assignment)
    end
    
    it 'belongs to an assignment group' do
      @assignment.assignment_group.should be_nil
      assignment_group = Factory(:assignment_group, :assignments => [@assignment])
      @assignment.assignment_group.should == assignment_group
    end
    
    it 'has many working_times' do
      @assignment.working_times.should == []
      working_time = @assignment.working_times.create!(:begin_date => Date.new, :duration => 0)
      @assignment.working_times.count.should == 1
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
    
    it 'requires a kind' do
      @assignment.kind = nil
      @assignment.should_not be_valid
    end
    
    it 'requires a colour' do
      @assignment.colour = nil
      @assignment.should_not be_valid
    end
    
    it 'requires a 0 - 1 rgba colour string' do
      %w{red    #ff0    #00ff00    0.5    -1,1,1,1}.each do |invalid|
        @assignment.colour = invalid
        @assignment.should_not be_valid, "#{invalid}"
      end
      
      %w{1,1,1,1    0,0,0,0    0.1,0.2,0.3,0.4    1,0,0.5,0.5}.each do |valid|
        @assignment.colour = valid
        @assignment.should be_valid, "#{valid}"
      end
    end
  end
  
  describe 'aliases' do
    before do
      @assignment = Factory(:assignment)
    end
    
    it "aliases 'color' to 'colour'" do
      @assignment.color.should == @assignment.colour
    end
  end
  
  describe '#colour' do
    before do
      @assignment = Factory(:assignment, :colour => '0.1,0.2,0.3,0.4')
    end
    
    it 'parses the colour attribute into a friendly hash' do
      @assignment.colour.should == { :red => 0.1, :green => 0.2, :blue => 0.3, :alpha => 0.4 }
    end
  end
  
end
