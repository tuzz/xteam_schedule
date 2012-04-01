require 'spec_helper'

describe XTeamSchedule::Holiday do

  describe 'associations' do
    before do
      @holiday = Factory(:holiday)
    end

    it 'belongs to a resource' do
      @holiday.schedule.should be_nil
      schedule = Factory(:schedule, :holidays => [@holiday])
      @holiday.schedule.should == schedule
    end

    it 'belongs to a resource' do
      @holiday.resource.should be_nil
      resource = Factory(:resource, :holidays => [@holiday])
      @holiday.resource.should == resource
    end
  end

  describe 'validations' do
    before do
      @holiday = Factory(:holiday)
    end

    it 'requires a begin date' do
      @holiday.begin_date = nil
      @holiday.should_not be_valid
    end

    it 'can not belong to both a schedule and resource' do
      @holiday.schedule = Factory(:schedule)
      @holiday.resource = Factory(:resource)
      @holiday.should_not be_valid
    end
  end

end
