require 'spec_helper'

describe XTeamSchedule::ResourceGroup do
  
  describe 'defaults' do
    it 'uses true for expanded_in_library' do
      XTeamSchedule::ResourceGroup.new.expanded_in_library.should be_true
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