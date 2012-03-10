require 'spec_helper'

describe XTeamSchedule::Base do
  
  describe '.build_schema' do
    it "builds a valid schema" do
      lambda { XTeamSchedule::Base.build_schema }.should_not raise_error
    end
  end
  
end
