require 'spec_helper'

describe XTeamSchedule::Schema do
  
  describe '.define' do
    it 'calls the contents of the block in the context of the class' do
      XTeamSchedule::Schema.should_receive(:foo).with(:bar)
      XTeamSchedule::Schema.should_receive(:baz).with(['quux'])
      XTeamSchedule::Schema.define { foo(:bar); baz ['quux'] }
    end
  end
  
  describe '.method_missing' do
    it 'acts as a proxy for the connection on Base' do
      XTeamSchedule::Base.connection.should_receive(:foo).with(:bar)
      XTeamSchedule::Base.connection.should_receive(:baz).with(['quux'])
      XTeamSchedule::Schema.foo(:bar)
      XTeamSchedule::Schema.baz(['quux'])
    end
  end
  
end
