require 'spec_helper'

describe XTeamSchedule::Interface do
  
  describe 'associations' do
    before do
      @interface = Factory(:interface)
    end
    
    it 'belongs to a schedule' do
      @interface.schedule.should be_nil
      schedule = Factory(:schedule, :interface => @interface)
      @interface.schedule.should == schedule
    end
  end
  
end
