require 'spec_helper'

describe XTeamSchedule::Composer do
  
  describe '.compose' do
    it 'saves the schedule' do
      schedule = XTeamSchedule::Schedule.new
      schedule.should be_new_record
      XTeamSchedule::Composer.compose(schedule)
      schedule.should_not be_new_record
    end
    
    it 'returns a hash' do
      schedule = XTeamSchedule::Schedule.new
      XTeamSchedule::Composer.compose(schedule).should be_a Hash
    end
  end
  
  describe '#initialize' do
    it 'sets the schedule and hash instance variables' do
      schedule = XTeamSchedule::Schedule.new
      composer = XTeamSchedule::Composer.new(schedule)
      composer.schedule.should == schedule
      composer.hash.should_not be_nil
    end
  end
  
  describe '#compose' do
    before do
      schedule = XTeamSchedule::Schedule.new
      @composer = XTeamSchedule::Composer.new(schedule)
    end
    
    it 'returns a hash' do
      @composer.compose.should be_a Hash
    end
    
    it 'calls compose_resource_groups!' do
      @composer.should_receive(:compose_resource_groups!)
      @composer.compose
    end
    
    it 'calls compose_resources!' do
      @composer.should_receive(:compose_resources!)
      @composer.compose
    end
    
    it 'calls compose_assignment_groups!' do
      @composer.should_receive(:compose_assignment_groups!)
      @composer.compose
    end
    
    it 'calls compose_assignments!' do
      @composer.should_receive(:compose_assignments!)
      @composer.compose
    end
    
    it 'calls compose_working_times!' do
      @composer.should_receive(:compose_working_times!)
      @composer.compose
    end
  end
  
  describe '#compose_resource_groups!' do
    before do
      @schedule = XTeamSchedule::Schedule.new
      @schedule.resource_groups.new(:name => 'foo', :expanded_in_library => true)
      @schedule.resource_groups.new(:name => 'bar', :expanded_in_library => false)
      @composer = XTeamSchedule::Composer.new(@schedule)
    end
    
    it 'creates resource groups' do
      @composer.send(:compose_resource_groups!)
      @composer.hash['resource groups'].count.should_not be_zero
    end
    
    it 'sets the name key correctly' do
      @composer.send(:compose_resource_groups!)
      @composer.hash['resource groups'].detect { |rg| rg['name'] == 'foo' }.should_not be_nil
      @composer.hash['resource groups'].detect { |rg| rg['name'] == 'bar' }.should_not be_nil
    end
    
    it 'sets the expanded in library key correctly' do
      @composer.send(:compose_resource_groups!)
      @composer.hash['resource groups'].detect { |rg| rg['expanded in library'] == true }.should_not be_nil
      @composer.hash['resource groups'].detect { |rg| rg['expanded in library'] == false }.should_not be_nil
    end
  end
  
  describe '#compose_resources!' do
    before do
      @schedule = XTeamSchedule::Schedule.new
      rg = @schedule.resource_groups.new(:name => 'foo')
      rg.resources.new(:displayed_in_planning => false, :email => 'foo@bar.com', :image => 'image',
                       :mobile => '0123456789', :name => 'bar', :phone => '9876543210')
      XTeamSchedule::Resource.new(:name => 'baz')
      @composer = XTeamSchedule::Composer.new(@schedule)
      @composer.send(:compose_resource_groups!)
    end
    
    it 'creates resources' do
      @composer.send(:compose_resources!)
      @composer.hash['resources'].count.should_not be_zero
    end
    
    it 'does not create orphaned resources' do
      @composer.send(:compose_resources!)
      @composer.hash['resources'].detect { |r| r['name'] == 'bar' }.should_not be_nil
      @composer.hash['resources'].detect { |r| r['name'] == 'baz' }.should be_nil
    end
    
    it 'sets the displayed in planning key correctly' do
      @composer.send(:compose_resources!)
      @composer.hash['resources'].detect { |r| r['displayedInPlanning'] == false }.should_not be_nil
    end
    
    it 'sets the email key correctly' do
      @composer.send(:compose_resources!)
      @composer.hash['resources'].detect { |r| r['email'] == 'foo@bar.com' }.should_not be_nil
    end
    
    it 'sets the image attribute correctly' do
      @composer.send(:compose_resources!)
      @composer.hash['resources'].detect { |r| r['image'].read == 'image' }.should_not be_nil
    end
    
    it 'sets the mobile key correctly' do
      @composer.send(:compose_resources!)
      @composer.hash['resources'].detect { |r| r['mobile'] == '0123456789' }.should_not be_nil
    end
    
    it 'sets the name key correctly' do
      @composer.send(:compose_resources!)
      @composer.hash['resources'].detect { |r| r['name'] == 'bar' }.should_not be_nil
    end
    
    it 'sets the phone key correctly' do
      @composer.send(:compose_resources!)
      @composer.hash['resources'].detect { |r| r['phone'] == '9876543210' }.should_not be_nil
    end
    
    it 'sets the group key correctly' do
      @composer.send(:compose_resources!)
      @composer.hash['resources'].detect { |r| r['group'] == 'foo' }.should_not be_nil
    end
  end
  
  describe '#compose_assignment_groups!' do
    before do
      @schedule = XTeamSchedule::Schedule.new
      @schedule.assignment_groups.new(:name => 'foo', :expanded_in_library => true)
      @schedule.assignment_groups.new(:name => 'bar', :expanded_in_library => false)
      @composer = XTeamSchedule::Composer.new(@schedule)
    end
    
    it 'creates assignment groups' do
      @composer.send(:compose_assignment_groups!)
      @composer.hash['task categories'].count.should_not be_zero
    end
    
    it 'sets the name key correctly' do
      @composer.send(:compose_assignment_groups!)
      @composer.hash['task categories'].detect { |ag| ag['name'] == 'foo' }.should_not be_nil
      @composer.hash['task categories'].detect { |ag| ag['name'] == 'bar' }.should_not be_nil
    end
    
    it 'sets the expanded in library key correctly' do
      @composer.send(:compose_assignment_groups!)
      @composer.hash['task categories'].detect { |ag| ag['expanded in library'] == true }.should_not be_nil
      @composer.hash['task categories'].detect { |ag| ag['expanded in library'] == false }.should_not be_nil
    end
  end
  
  describe '#compose_assignments!' do
    before do
      @schedule = XTeamSchedule::Schedule.new
      ag = @schedule.assignment_groups.new(:name => 'foo')
      ag.assignments.new(:name => 'bar', :colour => { :red => 0.1, :green => 0.2, :blue => 0.3 })
      XTeamSchedule::Assignment.new(:name => 'baz')
      @composer = XTeamSchedule::Composer.new(@schedule)
      @composer.send(:compose_assignment_groups!)
    end
    
    it 'creates assignments' do
      @composer.send(:compose_assignments!)
      @composer.hash['tasks'].count.should_not be_zero
    end
    
    it 'does not create orphaned assignments' do
      @composer.send(:compose_assignments!)
      @composer.hash['tasks'].detect { |a| a['name'] == 'bar' }.should_not be_nil
      @composer.hash['tasks'].detect { |a| a['name'] == 'baz' }.should be_nil
    end
    
    it 'sets the name key correctly' do
      @composer.send(:compose_assignments!)
      @composer.hash['tasks'].detect { |a| a['name'] == 'bar' }.should_not be_nil
    end
    
    it 'sets the kind key to 0' do
      @composer.send(:compose_assignments!)
      @composer.hash['tasks'].detect { |a| a['kind'] == 0 }.should_not be_nil
    end
    
    it 'sets the category attribute correctly' do
      @composer.send(:compose_assignments!)
      @composer.hash['tasks'].detect { |a| a['category'] == 'foo' }.should_not be_nil
    end
    
    it 'sets the colour attribute correctly' do
      @composer.send(:compose_assignments!)
      @composer.hash['tasks'].detect { |a| a['color'] == {
        'alpha' => 1, 'red' => 0.1, 'green' => 0.2, 'blue' => 0.3 }}.should_not be_nil
    end
  end
  
  describe '#compose_working_times!' do
    before do
      @schedule = XTeamSchedule::Schedule.new
      foo = @schedule.resource_groups.new(:name => 'foo')
      bar = @schedule.assignment_groups.new(:name => 'bar')
      baz = foo.resources.new(:name => 'baz')
      quux = bar.assignments.new(:name => 'quux')
      baz.working_times.new(:assignment => quux, :begin_date => Date.new(2000, 01, 15), :duration => 10, :notes => 'notes1')
      XTeamSchedule::WorkingTime.new(:assignment => quux, :begin_date => Date.new(2000, 02, 15), :duration => 11, :notes => 'notes2')
      baz.working_times.new(:begin_date => Date.new(2000, 03, 15), :duration => 12, :notes => 'notes3')
      XTeamSchedule::WorkingTime.new(:begin_date => Date.new(2000, 04, 15), :duration => 13, :notes => 'notes4')
      @composer = XTeamSchedule::Composer.new(@schedule)
      @composer.send(:compose_resource_groups!)
      @composer.send(:compose_resources!)
      @composer.send(:compose_assignment_groups!)
      @composer.send(:compose_assignments!)
    end
    
    def working_times
      @composer.hash['objectsForResources'].values.flatten
    end
    
    it 'creates working times' do
      @composer.send(:compose_working_times!)
      working_times.count.should_not be_zero
    end
    
    it 'does not create working times without a resource' do
      @composer.send(:compose_working_times!)
      working_times.detect { |wt| wt['notes'] == 'notes2' }.should be_nil
    end
    
    it 'does not create working times without an assignment' do
      @composer.send(:compose_working_times!)
      working_times.detect { |wt| wt['notes'] == 'notes3' }.should be_nil
    end
    
    it 'does not create orphaned working times' do
      @composer.send(:compose_working_times!)
      working_times.detect { |wt| wt['notes'] == 'notes4' }.should be_nil
    end
    
    it 'sets the begin date key correctly' do
      @composer.send(:compose_working_times!)
      working_times.detect { |wt| wt['begin date'] == '01/15/2000'}.should_not be_nil
    end
    
    it 'sets the duration key correctly' do
      @composer.send(:compose_working_times!)
      working_times.detect { |wt| wt['duration'] == 10 }.should_not be_nil
    end
    
    it 'sets the notes key correctly' do
      @composer.send(:compose_working_times!)
      working_times.detect { |wt| wt['notes'] == 'notes1' }.should_not be_nil
    end
    
    it 'sets the title key to empty string' do
      @composer.send(:compose_working_times!)
      working_times.detect { |wt| wt['title'].empty? }.should_not be_nil
    end
  end
  
  describe '#compose_colour' do
    before do
      schedule = XTeamSchedule::Schedule.new
      @composer = XTeamSchedule::Composer.new(schedule)
    end
    
    it 'creates a correspoding colour hash' do
      @composer.send(:compose_colour, { :red => 0.1, :green => 0.2, :blue => 0.3 }).
        should == { 'alpha' => 1, 'red' => 0.1, 'green' => 0.2, 'blue' => 0.3 }
    end
  end
  
  describe '#compose_date' do
    before do
      schedule = XTeamSchedule::Schedule.new
      @composer = XTeamSchedule::Composer.new(schedule)
    end
    
    it 'creates corresponding date strings' do
      @composer.send(:compose_date, Date.new(2000, 01, 20)).should == '01/20/2000'
      @composer.send(:compose_date, Date.new(1990, 12, 10)).should == '12/10/1990'
      @composer.send(:compose_date, Date.new(2010, 06, 07)).should == '06/07/2010'
    end
  end
end
