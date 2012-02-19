require 'spec_helper'

describe XTeamSchedule::Composer do
  
  describe '.compose' do
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
                       :mobile => '0123456789', 'name' => 'bar', 'phone' => '9876543210')
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
  
  describe '#compose_assignments' do
    before do
      @schedule = XTeamSchedule::Schedule.new
      ag = @schedule.assignment_groups.new(:name => 'foo')
      ag.assignments.new(:name => 'bar')
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
      @composer.hash['tasks'].detect { |r| r['name'] == 'bar' }.should_not be_nil
      @composer.hash['tasks'].detect { |r| r['name'] == 'baz' }.should be_nil
    end
    
    it 'sets the name key correctly' do
      @composer.send(:compose_assignments!)
      @composer.hash['tasks'].detect { |r| r['name'] == 'bar' }.should_not be_nil
    end
  end
end
