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
