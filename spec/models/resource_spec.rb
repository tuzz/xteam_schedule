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
      @resource.working_times.size.should == 1
      @resource.working_times.should == [working_time]
    end
    
    it 'destroys working_times on cascade' do
      @resource.working_times.create!(:begin_date => Date.new, :duration => 0)
      @resource.destroy
      XTeamSchedule::WorkingTime.count.should == 0
    end
    
    it 'delegates schedule to resource_group'
  end
  
  describe 'validations' do
    before do
      @resource = Factory(:resource)
    end
    
    it 'requires a name' do
      @resource.name = nil
      @resource.should_not be_valid
    end
    
    it 'requires unique names' do
      duplicate = XTeamSchedule::Resource.new(:name => @resource.name)
      duplicate.should_not be_valid
    end
  end
  
end
