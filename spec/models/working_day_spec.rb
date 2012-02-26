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
    
    it 'delegates schedule to weekly_working_schedule' do
      Factory(:weekly_working_schedule, :working_days => [@working_day])
      XTeamSchedule::WeeklyWorkingSchedule.any_instance.should_receive(:schedule)
      @working_day.schedule
    end
  end
  
  describe '#format_of_times' do
    before do
      @working_day = Factory(:working_day)
    end
    
    it 'skips validation for days off' do
      @working_day.day_end = 'invalid'
      @working_day.should_not be_valid
      @working_day.day_begin = nil
      @working_day.should be_valid
    end
    
    it 'skips break time validation when no breaks' do
      @working_day.break_end = 'invalid'
      @working_day.should_not be_valid
      @working_day.break_begin = nil
      @working_day.should be_valid
    end
    
    it 'accepts valid 24-hour times' do
      %w(00:00 23:59 10:01 12:12).each do |valid|
        @working_day.day_begin = valid
        @working_day.should be_valid, "#{valid}"
      end
    end
    
    it 'rejects invalid 24-hour times' do
      %w(foo 0:00 00.00 24:00 00:60 25:61).each do |invalid|
        @working_day.day_begin = invalid
        @working_day.should_not be_valid, "#{invalid}"
      end
    end
  end
  
end
