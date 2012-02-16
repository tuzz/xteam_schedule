require 'spec_helper'

describe XTeamSchedule::Resource do
  
  describe 'defaults' do
    it 'uses true for displayed_in_planning' do
      XTeamSchedule::Resource.new.displayed_in_planning.should be_true
    end
  end
  
  describe 'validations' do
    before do
      @resource = Factory(:resource)
    end
    
    it 'image must be valid base64' do
      @resource.image = '_invalid_'
      @resource.should_not be_valid
      @resource.errors[:image].first.should =~ /base64/i
      
      @resource.image = '=Valid\Base64='
      @resource.should be_valid
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
