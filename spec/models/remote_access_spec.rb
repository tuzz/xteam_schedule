require 'spec_helper'

describe XTeamSchedule::RemoteAccess do

  describe 'associations' do
    before do
      @remote_access = Factory(:remote_access)
    end

    it 'belongs to a schedule' do
      @remote_access.schedule.should be_nil
      schedule = Factory(:schedule, :remote_access => @remote_access)
      @remote_access.schedule.should == schedule
    end
  end

end
