require 'spec_helper'

describe XTeamSchedule::Assignment do
  
  describe 'validations' do
    before do
      @assignment = Factory(:assignment)
    end
    
    it 'requires a name' do
      @assignment.name = nil
      @assignment.should_not be_valid
    end
    
    it 'requires unique names' do
      duplicate = XTeamSchedule::Assignment.new(:name => @assignment.name)
      duplicate.should_not be_valid
    end
  end
  
end
