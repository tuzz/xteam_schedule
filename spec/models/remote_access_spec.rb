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

  describe 'validations' do
    before do
      @remote_access = Factory(:remote_access)
    end

    it 'requires a name in format XTEAM-DDMMYYYY-HHMM' do
      @remote_access.server_id = 1

      %w(XTEAM-01012000-0000 XTEAM-31122012-2359 XTEAM-05052005-0505).each do |valid|
        @remote_access.name = valid
        @remote_access.should be_valid, valid
      end

      %w(invalid XTEAM-01234567-0123 XTEAM-31022012-1200 XTEAM-01012012-2401).each do |invalid|
        @remote_access.name = invalid
        @remote_access.should_not be_valid, invalid
      end
    end
  end

end
