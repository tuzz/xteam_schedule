require 'spec_helper'

describe XTeamSchedule::ResourceGroup do
  
  describe 'validations' do
    before do
      @resource_group = Factory(:resource_group)
    end
    
    it 'requires a name' do
      @resource_group.update_attribute(:name, nil)
      @resource_group.should_not be_valid
    end
    
    it 'requires unique names' do
      duplicate = XTeamSchedule::ResourceGroup.new(:name => @resource_group.name)
      duplicate.should_not be_valid
    end
  end
  
end