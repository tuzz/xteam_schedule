require 'spec_helper'

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
    
    it 'calls parse_resources!' do
      @parser.should_receive(:parse_resources!)
      @parser.parse
    end
    
    it 'calls parse_assignment_groups!' do
      @parser.should_receive(:parse_assignment_groups!)
      @parser.parse
    end
  end
  
  describe '#parse_resource_groups!' do
    before do
      @hash = { 'resource groups' => [
        { 'name' => 'foo', 'expanded in library' => true },
        { 'name' => 'bar', 'expanded in library' => false  }
      ]}
      @parser = XTeamSchedule::Parser.new(@hash)
    end
    
    it 'creates resource groups' do
      @parser.send(:parse_resource_groups!)
      XTeamSchedule::ResourceGroup.count.should_not be_zero
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
  
  describe '#parse_resources!' do
    before do
      image = StringIO.new('image')
      @hash = {
        'resource groups' => [{ 'name' => 'foo'}],
        'resources' => [
          { 'displayedInPlanning' => false, 'email' => 'foo@bar.com', 'group' => 'foo',
            'image' => image, 'mobile' => '0123456789', 'name' => 'bar', 'phone' => '9876543210' },
          { 'group' => 'bar', 'name' => 'baz' }
        ]
      }
      @parser = XTeamSchedule::Parser.new(@hash)
      @parser.send(:parse_resource_groups!)
    end
    
    it 'creates resources' do
      @parser.send(:parse_resources!)
      XTeamSchedule::Resource.count.should_not be_zero
    end
    
    it 'does not create orphaned resources' do
      @parser.send(:parse_resources!)
      XTeamSchedule::Resource.find_by_name('bar').should_not be_nil
      XTeamSchedule::Resource.find_by_name('baz').should be_nil
    end
    
    it 'sets the displayed_in_planning attribute correctly' do
      @parser.send(:parse_resources!)
      XTeamSchedule::Resource.find_by_displayed_in_planning(false).should_not be_nil
    end
    
    it 'sets the email attribute correctly' do
      @parser.send(:parse_resources!)
      XTeamSchedule::Resource.find_by_email('foo@bar.com').should_not be_nil
    end
    
    it 'sets the image attribute correctly' do
      @parser.send(:parse_resources!)
      XTeamSchedule::Resource.find_by_image('image').should_not be_nil
    end
    
    it 'sets the mobile attribute correctly' do
      @parser.send(:parse_resources!)
      XTeamSchedule::Resource.find_by_mobile('0123456789').should_not be_nil
    end
    
    it 'sets the name attribute correctly' do
      @parser.send(:parse_resources!)
      XTeamSchedule::Resource.find_by_name('bar').should_not be_nil
    end
    
    it 'sets the phone attribute correctly' do
      @parser.send(:parse_resources!)
      XTeamSchedule::Resource.find_by_phone('9876543210').should_not be_nil
    end
  end
  
  describe '#parse_assignment_groups!' do
    before do
      @hash = { 'task categories' => [
        { 'name' => 'foo', 'expanded in library' => true },
        { 'name' => 'bar', 'expanded in library' => false  }
      ]}
      @parser = XTeamSchedule::Parser.new(@hash)
    end
    
    it 'creates assignment groups' do
      @parser.send(:parse_assignment_groups!)
      XTeamSchedule::AssignmentGroup.count.should_not be_zero
    end
    
    it 'sets the name attribute correctly' do
      @parser.send(:parse_assignment_groups!)
      XTeamSchedule::AssignmentGroup.find_by_name('foo').should_not be_nil
      XTeamSchedule::AssignmentGroup.find_by_name('bar').should_not be_nil
    end
    
    it 'sets the expanded_in_library attribute correctly' do
      @parser.send(:parse_assignment_groups!)
      XTeamSchedule::AssignmentGroup.find_all_by_expanded_in_library(true).count.should == 1
      XTeamSchedule::AssignmentGroup.find_all_by_expanded_in_library(false).count.should == 1
    end
  end
end
