require 'spec_helper'

describe XTeamSchedule::Schedule do
  
  describe 'defaults' do
    before do
      @now = Time.now
      Time.stub(:now).and_return(@now)
    end
    
    it 'uses 10 years ago for begin_date' do
      XTeamSchedule::Schedule.new.begin_date.should == (@now - 10.years).to_date
    end
    
    it 'uses 10 years from now for end_date' do
      XTeamSchedule::Schedule.new.end_date.should == (@now + 10.years).to_date
    end
  end
  
  describe 'associations' do
    before do
      @schedule = Factory(:schedule)
    end
    
    it 'has many resource_groups' do
      @schedule.resource_groups.should == []
      resource_group = @schedule.resource_groups.create!(:name => 'foo')
      @schedule.resource_groups.count.should == 1
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
      @schedule.assignment_groups.count.should == 1
      @schedule.assignment_groups.should == [assignment_group]
    end
    
    it 'destroys assignment_groups on cascade' do
      @schedule.assignment_groups.create!(:name => 'foo')
      @schedule.destroy
      XTeamSchedule::ResourceGroup.count.should == 0
    end
    
    it 'has many resources through resource groups' do
      foo = @schedule.resource_groups.create!(:name => 'foo')
      bar = @schedule.resource_groups.create!(:name => 'bar')
      baz = foo.resources.create!(:name => 'baz')
      quux = bar.resources.create!(:name => 'quux')
      @schedule.resources.should == [baz, quux]
    end
    
    it 'has many assignments through assignment groups' do
      foo = @schedule.assignment_groups.create(:name => 'foo')
      bar = @schedule.assignment_groups.create!(:name => 'bar')
      baz = foo.assignments.create!(:name => 'baz')
      quux = bar.assignments.create!(:name => 'quux')
      @schedule.assignments.should == [baz, quux]
    end
    
    it 'has many working_times through resources (through resource_groups)' do
      foo = @schedule.resource_groups.create(:name => 'foo')
      bar = @schedule.resource_groups.create!(:name => 'bar')
      baz = foo.resources.create!(:name => 'baz')
      quux = bar.resources.create!(:name => 'quux')
      zab = baz.working_times.create!(:begin_date => Date.new, :duration => 0)
      xuuq = quux.working_times.create!(:begin_date => Date.new, :duration => 0)
      @schedule.working_times.should == [zab, xuuq]
    end
    
    it 'has many working days through weekly working schedule' do
      @schedule.working_days.should == @schedule.weekly_working_schedule.working_days
    end
    
    it 'has one interface' do
      @schedule.interface.should_not be_nil
      @schedule.interface.class.should == XTeamSchedule::Interface
    end
    
    it 'has one weekly working schedule' do
      @schedule.weekly_working_schedule.should_not be_nil
      @schedule.weekly_working_schedule.class.should == XTeamSchedule::WeeklyWorkingSchedule
    end
  end
  
  describe '#set_default_interface' do
    before do
      @schedule = Factory(:schedule)
    end
    
    it "sets the interface if there isn't one already" do
      @schedule.interface = nil
      @schedule.send(:set_default_interface)
      @schedule.interface.should_not be_nil
    end
  end
  
  describe '#set_default_weekly_working_schedule' do
    before do
      @schedule = Factory(:schedule)
    end
    
    it "sets the weekly_working_schedule if there isn't one already" do
      @schedule.weekly_working_schedule = nil
      @schedule.send(:set_default_weekly_working_schedule)
      @schedule.weekly_working_schedule.should_not be_nil
    end
  end
  
end
