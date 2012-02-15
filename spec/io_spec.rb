require 'spec_helper'

describe XTeamSchedule::IO do
  
  describe '.read' do
    before do
      @filename = 'path/to/file'
    end
    
    it 'should use the plist gem to read from the file' do
      Plist.should_receive(:parse_xml).with(@filename)
      XTeamSchedule::IO.read(@filename)
    end
    
    it 'should return a hash corresponding to the parsed file' do
      stubbed_hash = { :foo => 'bar', :baz => 'quux' }
      Plist.stub(:parse_xml).and_return(stubbed_hash)
      return_value = XTeamSchedule::IO.read(@filename)
      return_value.should == stubbed_hash
    end
  end
  
end
