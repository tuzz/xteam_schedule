require 'spec_helper'

describe XTeamSchedule::DB do
  
  describe '.connect' do
    it "uses the 'sqlite3' adapter" do
      ActiveRecord::Base.should_receive(:establish_connection).with(hash_including(:adapter => 'sqlite3'))
      XTeamSchedule::DB.connect
    end
    
    it "uses an 'in memory' database" do
      ActiveRecord::Base.should_receive(:establish_connection).with(hash_including(:database => ':memory:'))
      XTeamSchedule::DB.connect
    end
  end
  
  describe '.build_schema' do
    before do
      XTeamSchedule::DB.connect
    end
    
    it "builds a valid schema" do
      lambda { XTeamSchedule::DB.build_schema }.should_not raise_error
    end
  end
  
end