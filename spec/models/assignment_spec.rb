require 'spec_helper'

describe XTeamSchedule::Assignment do
  
  describe 'defaults' do    
    it 'uses { :red => 0.5, :green => 0.5, :blue => 0.5 } for colour' do
      XTeamSchedule::Assignment.new.colour.should == { :red => 0.5, :green => 0.5, :blue => 0.5 }
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
    
    before do
      @schedule1 = Factory(:schedule)
      @schedule2 = Factory(:schedule)
      
      @assignment_group1 = Factory(:assignment_group, :schedule => @schedule1)
      @assignment_group2 = Factory(:assignment_group, :schedule => @schedule1)
      @assignment_group3 = Factory(:assignment_group, :schedule => @schedule2)
      
      @assignment = Factory(:assignment, :assignment_group => @assignment_group1)
    end
    
    it 'requires a name' do
      @assignment.name = nil
      @assignment.should_not be_valid
    end
    
    it 'requires unique names within the schedule' do
      n = @assignment.name
      duplicate_within_group = XTeamSchedule::Assignment.new(:name => n, :assignment_group => @assignment_group1)
      duplicate_within_schedule = XTeamSchedule::Assignment.new(:name => n, :assignment_group => @assignment_group2)
      duplicate_in_different_schedule = XTeamSchedule::Assignment.new(:name => n, :assignment_group => @assignment_group3)
      
      @assignment.should be_valid
      duplicate_within_group.should_not be_valid
      duplicate_within_schedule.should_not be_valid
      duplicate_in_different_schedule.should be_valid
    end
    
    it 'requires a colour' do
      @assignment.colour = nil
      @assignment.should_not be_valid
    end
    
    it 'requires a valid rgb hash' do
      valid = [
        { :red => 0.1, :green => 0.2, :blue => 0.3 },
        { :red => 0, :green => 1, :blue => 0.5 },
        { :red => 0.5, :green => 0.5, :blue => 0.5 }
      ]
      valid.each do |valid|
        @assignment.colour = valid
        @assignment.should be_valid, "#{valid}"
      end
      
      invalid = [
        { :red => 1.1, :green => 0.2, :blue => 0.3 },
        { :red => -0.1, :green => 0.2, :blue => 0.3 },
        { :red => 0.1, :green => 0.2, :blue => 0.3, :alpha => 1 },
        { :red => 0.1, :green => 0.2 },
        'string', ['array'], :symbol, Object.new
      ]
      invalid.each do |invalid|
        @assignment.colour = invalid
        @assignment.should_not be_valid, "#{invalid}"
      end
    end
  end
  
  describe 'aliases' do
    before do
      @assignment = Factory(:assignment)
    end
    
    it "aliases 'color' to 'colour'" do
      rgb_hash = { :red => 0.1, :green => 0.2, :blue => 0.3 }
      @assignment.colour = rgb_hash
      @assignment.color.should == rgb_hash
    end
    
    it "aliases 'color=' to 'colour'" do
      rgb_hash = { :red => 0.1, :green => 0.2, :blue => 0.3 }
      @assignment.color = rgb_hash
      @assignment.colour.should == rgb_hash
    end
  end
  
  describe '#symbolize_colour!' do
    before do
      @assignment = Factory(:assignment)
    end
    
    it 'converts hash keys to symbols' do
      @assignment.colour = { 'red' => 0.5, :green => 0.5, 'blue' => 0.5 }
      @assignment.send(:symbolize_colour!)
      @assignment.colour.should == { :red => 0.5, :green => 0.5, :blue => 0.5 }
    end
  end
  
  describe '#float_colour_values!' do
    before do
      @assignment = Factory(:assignment)
    end
    
    it 'converts hash values to floats' do
      @assignment.colour = { :red => '0.5', :green => 0.5, :blue => '0.5' }
      @assignment.send(:float_colour_values!)
      @assignment.colour.should == { :red => 0.5, :green => 0.5, :blue => 0.5 }
    end
  end
  
end
