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
    
    it 'has many working days' do
      @weekly_working_schedule.working_days = []
      working_day = @weekly_working_schedule.working_days.create!(:name => 'Monday', :day_begin => nil)
      @weekly_working_schedule.working_days.count.should == 1
      @weekly_working_schedule.working_days.should == [working_day]
    end
    
    it 'destroys working days on cascade' do
      @weekly_working_schedule.working_days.create!(:name => 'Monday', :day_begin => nil)
      @weekly_working_schedule.destroy
      XTeamSchedule::WorkingDay.count.should == 0
    end
  end
  
  describe '#set_default_working_days' do
    before do
      @weekly_working_schedule = Factory(:weekly_working_schedule)
    end
    
    it "sets a typical working week if there are no working days" do
      day_names = XTeamSchedule::WorkingDay::WORKING_DAY_NAMES
      weekdays = day_names[0..4]
      @weekly_working_schedule.working_days.each do |day|
        day.name.should == day_names.shift
        day.day_begin.should == (weekdays.shift.present? ? '09:00' : nil)
        day.day_end.should == '17:00'
        day.break_begin.should == '12:00'
        day.break_end.should == '13:00'
      end
    end
  end
  
end
