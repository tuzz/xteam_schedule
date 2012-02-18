require 'spec_helper'

describe XTeamSchedule::WorkingTime do
  
  describe 'validations' do
    before do
      @working_time = Factory(:working_time)
    end
    
    it 'requires a begin_date' do
      @working_time.begin_date = nil
      @working_time.should_not be_valid
    end
    
    it 'requires a duration' do
      @working_time.duration = nil
      @working_time.should_not be_valid
    end
  end
  
end
