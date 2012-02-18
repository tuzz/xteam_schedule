describe XTeamSchedule::Parser do
  
  describe '.parse' do
    it 'returns an instance of Schedule' do
      XTeamSchedule::Parser.parse({}).should be_an XTeamSchedule::Schedule
    end
  end
  
  describe '#initialize' do
    it 'sets the hash and schedule instance variables' do
      hash = { :foo => 'bar' }
      parser = XTeamSchedule::Parser.new(hash)
      parser.hash.should == hash
      parser.schedule.should_not be_nil
    end
    
    it 'saves the schedule so that children may be created' do
      XTeamSchedule::Parser.new({}).schedule.should_not be_new_record
    end
  end
  
  describe '#parse' do
    before do
      @parser = XTeamSchedule::Parser.new({})
    end
    
    it 'returns an instance of Schedule' do
      @parser.parse.should be_an XTeamSchedule::Schedule
    end
    
    it 'calls parse_resource_groups!' do
      @parser.should_receive(:parse_resource_groups!)
      @parser.parse
    end
  end
  
  describe '#parse_resource_groups!' do
    before do
      @hash = { 'resource groups' => [
        { 'name' => 'foo', 'expanded in library' => 'Yes' },
        { 'name' => 'bar', 'expanded in library' => 'No'  }
      ]}
      @parser = XTeamSchedule::Parser.new(@hash)
    end
    
    it 'creates resource groups' do
      @parser.send(:parse_resource_groups!)
      XTeamSchedule::ResourceGroup.count.should == 2
    end
    
    it 'sets the name attribute correctly' do
      @parser.send(:parse_resource_groups!)
      XTeamSchedule::ResourceGroup.find_by_name('foo').should_not be_nil
      XTeamSchedule::ResourceGroup.find_by_name('bar').should_not be_nil
    end
    
    it 'sets the expanded_in_library attribute correctly' do
      @parser.send(:parse_resource_groups!)
      XTeamSchedule::ResourceGroup.find_all_by_expanded_in_library(true).count.should == 1
      XTeamSchedule::ResourceGroup.find_all_by_expanded_in_library(false).count.should == 1
    end
  end
  
  describe '#boolean' do
    before do
      @parser = XTeamSchedule::Parser.new(@hash)
    end
    
    it 'returns true when the given string matches yes' do
      %w(yes Yes YES yesterday bayes).each { |word| @parser.send(:boolean, word).should be_true }
    end
    
    it "returns false when the given string doesn't match yes" do
      %w(none of these should match).each { |word| @parser.send(:boolean, word).should be_false }
    end
  end
  
end
