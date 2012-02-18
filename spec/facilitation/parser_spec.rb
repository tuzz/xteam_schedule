describe XTeamSchedule::Parser do
  
  describe '.parse' do
    it 'returns an instance of XTeamSchedule' do
      XTeamSchedule::Parser.parse({}).should be_an XTeamSchedule
    end
  end
  
  describe '#initialize' do
    it 'sets the hash and schedule instance variables' do
      hash = { :foo => 'bar' }
      parser = XTeamSchedule::Parser.new(hash)
      parser.hash.should == hash
      parser.schedule.should_not be_nil
    end
  end
  
  describe '#parse' do
    it 'returns an instance of XTeamSchedule' do
      XTeamSchedule::Parser.new({}).parse.should be_an XTeamSchedule
    end
  end
  
end