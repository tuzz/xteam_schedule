require 'spec_helper'

describe XTeamSchedule do
  
  describe '#initialize' do
    before do
      @hash = { 'resource groups' => [{ 'expandedInLibrary' => true, 'name' => 'foo'}]}
      XTeamSchedule::IO.stub!(:read).and_return(@hash)
    end
    
    it 'can be initialized with no parameters' do
      lambda {
        schedule = XTeamSchedule.new
        schedule.resource_groups.should be_empty
      }.should_not raise_error
    end
    
    it 'can be initialized by passing in a hash' do
      lambda {
        schedule = XTeamSchedule.new(@hash)
        schedule.resource_groups.should_not be_empty
      }.should_not raise_error
    end
    
    it 'can be initialized by passing in a filename' do
      lambda {
        schedule = XTeamSchedule.new('path/to/file')
        schedule.resource_groups.should_not be_empty
      }.should_not raise_error
    end
  end
  
  describe '#write' do
    before do
      @schedule = XTeamSchedule.new
      @hash = @schedule.hash
    end
    
    it 'writes the schedule to a file' do
      XTeamSchedule::IO.should_receive(:write).with(@hash, 'path/to/file')
      @schedule.write('path/to/file')
    end
  end
  
  describe '#hash' do
    before do
      @schedule = XTeamSchedule.new
    end
    
    it 'returns the composition of the schedule' do
      XTeamSchedule::Composer.should_receive(:compose).with(@schedule)
      @schedule.hash
    end
  end
  
  describe '.inspect' do
    it "uses returns Schedule.inspect" do
      XTeamSchedule.inspect.should == XTeamSchedule::Schedule.inspect
    end
  end
  
end