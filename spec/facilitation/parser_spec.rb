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
    
    it 'calls parse_assignments!' do
      @parser.should_receive(:parse_assignments!)
      @parser.parse
    end
    
    it 'calls parse_working_times!' do
      @parser.should_receive(:parse_working_times!)
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
      XTeamSchedule::ResourceGroup.find_by_expanded_in_library(true).should_not be_nil
      XTeamSchedule::ResourceGroup.find_by_expanded_in_library(false).should_not be_nil
    end
  end
  
  describe '#parse_resources!' do
    before do
      image = StringIO.new('image')
      @hash = {
        'resource groups' => [{ 'name' => 'foo'}],
        'resources' => [
          { 'displayedInPlanning' => false, 'email' => 'foo@bar.com', 'group' => 'foo', 'kind' => 0,
            'image' => image, 'mobile' => '0123456789', 'name' => 'bar', 'phone' => '9876543210' },
          { 'group' => 'bar', 'name' => 'baz', 'kind' => 0 }
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
    
    it 'sets the kind attribute correctly' do
      @parser.send(:parse_resources!)
      XTeamSchedule::Resource.find_by_kind(0).should_not be_nil
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
      XTeamSchedule::AssignmentGroup.find_by_expanded_in_library(true).should_not be_nil
      XTeamSchedule::AssignmentGroup.find_by_expanded_in_library(false).should_not be_nil
    end
  end
  
  describe '#parse_assignments!' do
    before do
      @hash = {
        'task categories' => [{ 'name' => 'foo' }],
        'tasks' => [{ 'category' => 'foo', 'name' => 'bar', 'kind' => 0 },
                    { 'category' => 'baz', 'name' => 'quux', 'kind' => 1 }]
      }
      @parser = XTeamSchedule::Parser.new(@hash)
      @parser.send(:parse_assignment_groups!)
    end
    
    it 'creates assignments' do
      @parser.send(:parse_assignments!)
      XTeamSchedule::Assignment.count.should_not be_zero
    end
    
    it 'does not create orphaned assignments' do
      @parser.send(:parse_assignments!)
      XTeamSchedule::Assignment.find_by_name('bar').should_not be_nil
      XTeamSchedule::Assignment.find_by_name('quux').should be_nil
    end
    
    it 'sets the name attribute correctly' do
      @parser.send(:parse_assignments!)
      XTeamSchedule::Assignment.find_by_name('bar').should_not be_nil
    end
    
    it 'sets the kind attribute correctly' do
      @parser.send(:parse_assignments!)
      XTeamSchedule::Assignment.find_by_kind('0').should_not be_nil
    end
  end
  
  describe '#parse_working_times!' do
    before do
      @hash = {
        'resource groups' => [{ 'name' => 'foo' }],
        'task categories' => [{ 'name' => 'bar' }],
        'resources' => [{ 'name' => 'baz', 'group' => 'foo', 'kind' => 0 }],
        'tasks' => [{ 'name' => 'quux', 'category' => 'bar', 'kind' => 0 }],
        'objectsForResources' => [
          ['baz', [{ 'task' => 'quux', 'begin date' => '01/15/2000', 'duration' => 10, 'notes' => 'notes1'}]],
          ['zab', [{ 'task' => 'quux', 'begin date' => '02/15/2000', 'duration' => 11, 'notes' => 'notes2'}]],
          ['baz', [{ 'task' => 'xuuq', 'begin date' => '03/15/2000', 'duration' => 12, 'notes' => 'notes3'}]],
          ['zab', [{ 'task' => 'xuuq', 'begin date' => '04/15/2000', 'duration' => 13, 'notes' => 'notes4'}]]
        ]
      }
      @parser = XTeamSchedule::Parser.new(@hash)
      @parser.send(:parse_resource_groups!)
      @parser.send(:parse_resources!)
      @parser.send(:parse_assignment_groups!)
      @parser.send(:parse_assignments!)
    end
    
    it 'creates working times' do
      @parser.send(:parse_working_times!)
      XTeamSchedule::WorkingTime.count.should_not be_zero
    end
    
    it 'does not create working times without a resource' do
      @parser.send(:parse_working_times!)
      XTeamSchedule::WorkingTime.find_by_notes('notes2').should be_nil
    end
    
    it 'does not create working times without an assignment' do
      @parser.send(:parse_working_times!)
      XTeamSchedule::WorkingTime.find_by_notes('notes3').should be_nil
    end
    
    it 'does not create orphaned working times' do
      @parser.send(:parse_working_times!)
      XTeamSchedule::WorkingTime.find_by_notes('notes4').should be_nil
    end
    
    it 'sets the begin_date attribute correctly' do
      @parser.send(:parse_working_times!)
      XTeamSchedule::WorkingTime.find_by_notes('notes1').begin_date.should == Date.new(2000, 01, 15)
    end
    
    it 'sets the duration attribute correctly' do
      @parser.send(:parse_working_times!)
      XTeamSchedule::WorkingTime.find_by_notes('notes1').duration.should == 10
    end
    
    it 'sets the notes attribute correctly' do
      @parser.send(:parse_working_times!)
      XTeamSchedule::WorkingTime.find_by_notes('notes1').should_not be_nil
    end
  end
  
  describe '#parse_date' do
    before do
      @parser = XTeamSchedule::Parser.new({})
    end
    
    it 'creates corresponding date objects' do
      @parser.send(:parse_date, '01/20/2000').should == Date.new(2000, 01, 20)
      @parser.send(:parse_date, '12/10/1990').should == Date.new(1990, 12, 10)
      @parser.send(:parse_date, '06/07/2010').should == Date.new(2010, 06, 07)
    end
  end
  
end
