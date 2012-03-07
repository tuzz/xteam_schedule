require 'spec_helper'

describe XTeamSchedule::Base do
  
  describe '.connect' do
    it "uses the 'sqlite3' adapter" do
      ActiveRecord::Base.should_receive(:establish_connection).with(hash_including(:adapter => 'sqlite3'))
      XTeamSchedule::Base.connect
    end
    
    it "uses an 'in memory' database" do
      ActiveRecord::Base.should_receive(:establish_connection).with(hash_including(:database => ':memory:'))
      XTeamSchedule::Base.connect
    end
  end
  
  describe '.build_schema' do
    before do
      XTeamSchedule::Base.connect
    end
    
    it 'runs quietly' do
      XTeamSchedule::Base.build_schema
      ActiveRecord::Schema.verbose.should be_false
    end
    
    it "builds a valid schema" do
      lambda { XTeamSchedule::Base.build_schema }.should_not raise_error
    end
  end
  
end
