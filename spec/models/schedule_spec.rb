require 'spec_helper'

describe XTeamSchedule::Schedule do

  describe 'defaults' do
    before do
      @now = Time.now
      Time.stub(:now).and_return(@now)
    end

    # activesupport's calculation has changed between versions, so tolerance seems sensible
    def acceptable_dates(date, tolerance)
      tolerance = -tolerance..tolerance unless tolerance.class == Range
      tolerance.map { |i| (date + i.days).to_date }
    end

    it 'uses 10 years ago for begin_date' do
      acceptable_dates(@now - 10.years, 10).should include(XTeamSchedule::Schedule.new.begin_date)
    end

    it 'uses 10 years from now for end_date' do
      acceptable_dates(@now + 10.years, 10).should include(XTeamSchedule::Schedule.new.end_date)
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

    it 'has many holidays' do
      @schedule.holidays.should == []
      holiday = @schedule.holidays.create!(:begin_date => Date.today)
      @schedule.holidays.count.should == 1
      @schedule.holidays.should == [holiday]
    end

    it 'destroys holidays on cascade' do
      @schedule.holidays.create!(:begin_date => Date.today)
      @schedule.destroy
      XTeamSchedule::Holiday.count.should == 0
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

    it 'has one remote access' do
      @schedule.remote_access.should_not be_nil
      @schedule.remote_access.class.should == XTeamSchedule::RemoteAccess
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

  describe '#set_default_remote_access' do
    before do
      @schedule = Factory(:schedule)
    end

    it "sets the remote_access if there isn't one already" do
      @schedule.remote_access = nil
      @schedule.send(:set_default_remote_access)
      @schedule.remote_access.should_not be_nil
    end
  end

end
