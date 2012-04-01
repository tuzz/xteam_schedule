require 'spec_helper'

describe XTeamSchedule::Resource do

  describe 'defaults' do
    it 'uses true for displayed_in_planning' do
      XTeamSchedule::Resource.new.displayed_in_planning.should be_true
    end
  end

  describe 'associations' do
    before do
      @resource = Factory(:resource)
    end

    it 'belongs to a resource group' do
      @resource.resource_group.should be_nil
      resource_group = Factory(:resource_group, :resources => [@resource])
      @resource.resource_group.should == resource_group
    end

    it 'has many working_times' do
      @resource.working_times.should == []
      working_time = @resource.working_times.create!(:begin_date => Date.new, :duration => 0)
      @resource.working_times.count.should == 1
      @resource.working_times.should == [working_time]
    end

    it 'destroys working_times on cascade' do
      @resource.working_times.create!(:begin_date => Date.new, :duration => 0)
      @resource.destroy
      XTeamSchedule::WorkingTime.count.should == 0
    end

    it 'has many holidays' do
      @resource.holidays.should == []
      holiday = @resource.holidays.create!(:begin_date => Date.today)
      @resource.holidays.count.should == 1
      @resource.holidays.should == [holiday]
    end

    it 'destroys holidays on cascade' do
      @resource.holidays.create!(:begin_date => Date.today)
      @resource.destroy
      XTeamSchedule::Holiday.count.should == 0
    end

    it 'delegates schedule to resource_group' do
      Factory(:resource_group, :resources => [@resource])
      XTeamSchedule::ResourceGroup.any_instance.should_receive(:schedule)
      @resource.schedule
    end
  end

  describe 'validations' do
    before do
      @schedule1 = Factory(:schedule)
      @schedule2 = Factory(:schedule)

      @resource_group1 = Factory(:resource_group, :schedule => @schedule1)
      @resource_group2 = Factory(:resource_group, :schedule => @schedule1)
      @resource_group3 = Factory(:resource_group, :schedule => @schedule2)

      @resource = Factory(:resource, :resource_group => @resource_group1)
    end

    it 'requires a name' do
      @resource.name = nil
      @resource.should_not be_valid
    end

    it 'requires unique names within the schedule' do
      n = @resource.name
      duplicate_within_group = XTeamSchedule::Resource.new(:name => n, :resource_group => @resource_group1)
      duplicate_within_schedule = XTeamSchedule::Resource.new(:name => n, :resource_group => @resource_group2)
      duplicate_in_different_schedule = XTeamSchedule::Resource.new(:name => n, :resource_group => @resource_group3)

      @resource.should be_valid
      duplicate_within_group.should_not be_valid
      duplicate_within_schedule.should_not be_valid
      duplicate_in_different_schedule.should be_valid
    end
  end

end
