require 'spec_helper'

describe XTeamSchedule::WeeklyWorkingSchedule do
  
  describe 'associations' do
    before do
      @weekly_working_schedule = Factory(:weekly_working_schedule)
    end
    
    it 'belongs to a schedule' do
      @weekly_working_schedule.schedule.should be_nil
      schedule = Factory(:schedule, :weekly_working_schedule => @weekly_working_schedule)
      @weekly_working_schedule.schedule.should == schedule
    end
  end
  
end