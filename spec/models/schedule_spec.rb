require 'spec_helper'

describe XTeamSchedule::Schedule do
  
  describe 'associations' do
    before do
      @schedule = Factory(:schedule)
    end
    
    it 'has many resource_groups' do
      @schedule.resource_groups.should == []
      resource_group = @schedule.resource_groups.create!(:name => 'foo')
      @schedule.resource_groups.size.should == 1
      @schedule.resource_groups.should == [resource_group]
    end
    
    it 'destroys resource_groups on cascade' do
      @schedule.resource_groups.create!(:name => 'foo')
      @schedule.destroy
      XTeamSchedule::ResourceGroup.count.should == 0
    end
  end
  
end
