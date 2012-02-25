require 'spec_helper'

describe XTeamSchedule::WorkingDay do
  
  describe 'associations' do
    before do
      @working_day = Factory(:working_day)
    end
    
    it 'belongs to a weekly_working_schedule' do
      @working_day.weekly_working_schedule.should be_nil
      weekly_working_schedule = Factory(:weekly_working_schedule, :working_days => [@working_day])
      @working_day.weekly_working_schedule.should == weekly_working_schedule
    end
  end
  
end
