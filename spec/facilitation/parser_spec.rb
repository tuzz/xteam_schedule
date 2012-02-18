describe XTeamSchedule::Parser do
  
  describe '.parse' do
    it 'should return an instance of XTeamSchedule' do
      XTeamSchedule::Parser.parse({}).class.should == XTeamSchedule
    end
  end
  
end
