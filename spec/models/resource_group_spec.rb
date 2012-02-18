require 'spec_helper'

describe XTeamSchedule::ResourceGroup do
  
  describe 'defaults' do
    it 'uses true for expanded_in_library' do
      XTeamSchedule::ResourceGroup.new.expanded_in_library.should be_true
    end
  end
  
  describe 'associations' do
    before do
      @resource_group = Factory(:resource_group)
    end
    
    it 'belongs to a schedule' do
      @resource_group.schedule.should be_nil
      schedule = Factory(:schedule, :resource_groups => [@resource_group])
      @resource_group.schedule.should == schedule
    end
    
    it 'has many resources' do
      @resource_group.resources.should == []
      resource = @resource_group.resources.create!(:name => 'foo')
      @resource_group.resources.size.should == 1
      @resource_group.resources.should == [resource]
    end
    
    it 'destroys resources on cascade' do
      @resource_group.resources.create!(:name => 'foo')
      @resource_group.destroy
      XTeamSchedule::Resource.count.should == 0
    end
  end
  
  describe 'validations' do
    before do
      @resource_group = Factory(:resource_group)
    end
    
    it 'requires a name' do
      @resource_group.name = nil
      @resource_group.should_not be_valid
    end
    
    it 'requires unique names' do
      duplicate = XTeamSchedule::ResourceGroup.new(:name => @resource_group.name)
      duplicate.should_not be_valid
    end
  end
  
end
