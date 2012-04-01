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
      schedule = XTeamSchedule::Schedule.create!
      XTeamSchedule::Composer.compose(schedule).should be_a Hash
    end
  end

  describe '#initialize' do
    it 'sets the schedule and hash instance variables' do
      schedule = XTeamSchedule::Schedule.create!
      composer = XTeamSchedule::Composer.new(schedule)
      composer.schedule.should == schedule
      composer.hash.should_not be_nil
    end
  end

  describe '#compose' do
    before do
      schedule = XTeamSchedule::Schedule.create!
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

    it 'calls compose_interface!' do
      @composer.should_receive(:compose_interface!)
      @composer.compose
    end

    it 'calls compose_weekly_working_schedule!' do
      @composer.should_receive(:compose_weekly_working_schedule!)
      @composer.compose
    end

    it 'calls compose_holidays!' do
      @composer.should_receive(:compose_holidays!)
      @composer.compose
    end

    it 'calls compose_schedule!' do
      @composer.should_receive(:compose_schedule!)
      @composer.compose
    end
  end

  describe '#compose_resource_groups!' do
    before do
      @schedule = XTeamSchedule::Schedule.create!
      @schedule.resource_groups.create!(:name => 'foo', :expanded_in_library => true)
      @schedule.resource_groups.create!(:name => 'bar', :expanded_in_library => false)
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
      @schedule = XTeamSchedule::Schedule.create!
      rg = @schedule.resource_groups.create!(:name => 'foo')
      rg.resources.create!(:displayed_in_planning => false, :email => 'foo@bar.com', :image => Base64.encode64('image'),
                       :mobile => '0123456789', :name => 'bar', :phone => '9876543210')
      XTeamSchedule::Resource.create!(:name => 'baz')
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
      @schedule = XTeamSchedule::Schedule.create!
      @schedule.assignment_groups.create!(:name => 'foo', :expanded_in_library => true)
      @schedule.assignment_groups.create!(:name => 'bar', :expanded_in_library => false)
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
      @schedule = XTeamSchedule::Schedule.create!
      ag = @schedule.assignment_groups.create!(:name => 'foo')
      ag.assignments.create!(:name => 'bar', :colour => { :red => 0.1, :green => 0.2, :blue => 0.3 })
      XTeamSchedule::Assignment.create!(:name => 'baz')
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
      @schedule = XTeamSchedule::Schedule.create!
      foo = @schedule.resource_groups.create!(:name => 'foo')
      bar = @schedule.assignment_groups.create!(:name => 'bar')
      baz = foo.resources.create!(:name => 'baz')
      quux = bar.assignments.create!(:name => 'quux')
      baz.working_times.create!(:assignment => quux, :begin_date => Date.new(2000, 01, 15), :duration => 10, :notes => 'notes1')
      XTeamSchedule::WorkingTime.create!(:assignment => quux, :begin_date => Date.new(2000, 02, 15), :duration => 11, :notes => 'notes2')
      baz.working_times.create!(:begin_date => Date.new(2000, 03, 15), :duration => 12, :notes => 'notes3')
      XTeamSchedule::WorkingTime.create!(:begin_date => Date.new(2000, 04, 15), :duration => 13, :notes => 'notes4')
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

  describe '#compose_interface!' do
    before do
      @schedule = XTeamSchedule::Schedule.create!
      @schedule.interface.update_attributes!(
        :display_assignments_name => false,
        :display_resources_name => true,
        :display_working_hours => true,
        :display_resources_pictures => false,
        :display_total_of_working_hours => true,
        :display_assignments_notes => false,
        :display_absences => false,
        :time_granularity => XTeamSchedule::Interface::TIME_GRANULARITIES[:day]
      )
      @composer = XTeamSchedule::Composer.new(@schedule)
    end

    it 'sets the display_assignments_name key correctly' do
      @composer.send(:compose_interface!)
      @composer.hash['display task names'].should_not be_nil
      @composer.hash['display task names'].should be_false
    end

    it 'sets the display_resources_name key correctly' do
      @composer.send(:compose_interface!)
      @composer.hash['display resource names'].should be_true
    end

    it 'sets the display_working_hours key correctly' do
      @composer.send(:compose_interface!)
      @composer.hash['display worked time'].should be_true
    end

    it 'sets the display_resources_pictures key correctly' do
      @composer.send(:compose_interface!)
      @composer.hash['display resource icons'].should_not be_nil
      @composer.hash['display resource icons'].should be_false
    end

    it 'sets the display_total_of_working_hours key correctly' do
      @composer.send(:compose_interface!)
      @composer.hash['display resource totals'].should be_true
    end

    it 'sets the display_assignments_notes key correctly' do
      @composer.send(:compose_interface!)
      @composer.hash['display task notes'].should_not be_nil
      @composer.hash['display task notes'].should be_false
    end

    it 'sets the display_absences key correctly' do
      @composer.send(:compose_interface!)
      @composer.hash['display absence cells'].should_not be_nil
      @composer.hash['display absence cells'].should be_false
    end

    it 'sets the time_granularity key correctly' do
      @composer.send(:compose_interface!)
      day_granularity = XTeamSchedule::Interface::TIME_GRANULARITIES[:day]
      @composer.hash['interface status']['latest time navigation mode'].should == day_granularity
    end
  end

  describe '#compose_weekly_working_schedule!' do
    before do
      @schedule = XTeamSchedule::Schedule.create!
      @composer = XTeamSchedule::Composer.new(@schedule)
    end

    def working_schedule
      @composer.hash['settings']['working schedule']
    end

    it "sets the required 'days off' key" do
      @composer.send(:compose_weekly_working_schedule!)
      @composer.hash['settings']['days off'].should == []
    end

    it 'creates working days' do
      @composer.send(:compose_weekly_working_schedule!)
      working_schedule.should_not be_empty
    end

    it 'sets the name key correctly' do
      @composer.send(:compose_weekly_working_schedule!)
      working_schedule['monday'].should_not be_nil
    end

    it 'sets the day_begin key correctly' do
      @composer.send(:compose_weekly_working_schedule!)
      working_schedule['monday']['begin'].should == 540
    end

    it 'sets the day_end key correctly' do
      @composer.send(:compose_weekly_working_schedule!)
      working_schedule['monday']['end'].should == 1020
    end

    it 'sets the break_begin key correctly' do
      @composer.send(:compose_weekly_working_schedule!)
      working_schedule['pause_monday']['begin'].should == 720
    end

    it 'sets the break_end key correctly' do
      @composer.send(:compose_weekly_working_schedule!)
      working_schedule['pause_monday']['end'].should == 780
    end

    it 'sets the break duration correctly' do
      @composer.send(:compose_weekly_working_schedule!)
      working_schedule['pause_monday']['duration'].should == 60
    end

    it 'sets the worked key correctly' do
      @composer.send(:compose_weekly_working_schedule!)
      working_schedule['monday']['worked'].should == 'yes'
      working_schedule['saturday']['worked'].should == 'no'
    end

    it 'skips breaks correctly' do
      @composer.send(:compose_weekly_working_schedule!)
      working_schedule['pause_monday']['worked'].should == 'yes'
      working_schedule['pause_saturday']['worked'].should be_nil
    end
  end

  describe '#compose_holidays!' do
    before do
      schedule = XTeamSchedule::Schedule.create!
      @composer = XTeamSchedule::Composer.new(schedule)
    end

    it 'calls compose_schedule_holidays!' do
      @composer.should_receive(:compose_schedule_holidays!)
      @composer.send(:compose_holidays!)
    end

    it 'calls compose_resource_holidays!' do
      @composer.should_receive(:compose_resource_holidays!)
      @composer.send(:compose_holidays!)
    end
  end

  describe '#compose_schedule_holidays!' do
    before do
      @schedule = XTeamSchedule::Schedule.create!
      @schedule.holidays.create!(:begin_date => Date.new(2000, 01, 15), :end_date => Date.new(2000, 01, 16))
      @schedule.holidays.create!(:begin_date => Date.new(2000, 02, 15), :name => 'Hol')
      @composer = XTeamSchedule::Composer.new(@schedule)
    end

    def holidays
      @composer.hash['settings']['days off']
    end

    it 'creates holidays' do
      @composer.send(:compose_schedule_holidays!)
      holidays.should_not be_empty
    end

    it 'sets the begin date key correctly' do
      @composer.send(:compose_schedule_holidays!)
      holidays.detect { |h| h['begin date'] == '01/15/2000' }.should_not be_nil
    end

    it 'sets the end date key correctly' do
      @composer.send(:compose_schedule_holidays!)
      holidays.detect { |h| h['end date'] == '01/16/2000' }.should_not be_nil
    end

    it 'sets the name key correctly' do
      @composer.send(:compose_schedule_holidays!)
      holidays.detect { |h| h['name'] == 'Hol' }.should_not be_nil
    end
  end

  describe '#compose_resource_holidays' do
    before do
      @schedule = XTeamSchedule::Schedule.create!
      resource_group = @schedule.resource_groups.create!(:name => 'foo')
      @resource = resource_group.resources.create!(:name => 'bar')
      @resource.holidays.create!(:begin_date => Date.new(2000, 01, 15), :end_date => Date.new(2000, 01, 16))
      @resource.holidays.create!(:begin_date => Date.new(2000, 02, 15), :name => 'Hol')
      @composer = XTeamSchedule::Composer.new(@schedule)
      @composer.send(:compose_resource_groups!)
      @composer.send(:compose_resources!)
    end

    def resource_holidays
      @composer.hash['resources'].first['days off']
    end

    it 'creates holidays' do
      @composer.send(:compose_resource_holidays!)
      resource_holidays.should_not be_empty
    end

    it 'sets the begin date key correctly' do
      @composer.send(:compose_resource_holidays!)
      resource_holidays.detect { |h| h['begin date'] == '01/15/2000' }.should_not be_nil
    end

    it 'sets the end date key correctly' do
      @composer.send(:compose_resource_holidays!)
      resource_holidays.detect { |h| h['end date'] == '01/16/2000' }.should_not be_nil
    end

    it 'sets the name key correctly' do
      @composer.send(:compose_resource_holidays!)
      resource_holidays.detect { |h| h['name'] == 'Hol' }.should_not be_nil
    end
  end

  describe '#compose_schedule' do
    before do
      @schedule = XTeamSchedule::Schedule.create!
      @schedule.begin_date = Date.new(2010, 03, 31)
      @schedule.end_date = Date.new(2015, 12, 25)
      @composer = XTeamSchedule::Composer.new(@schedule)
    end

    it 'sets the begin_date key correctly' do
      @composer.send(:compose_schedule!)
      @composer.hash['begin date'].should == '03/31/2010'
    end

    it 'sets the end_date key correctly' do
      @composer.send(:compose_schedule!)
      @composer.hash['end date'].should == '12/25/2015'
    end
  end

  describe '#compose_colour' do
    before do
      schedule = XTeamSchedule::Schedule.create!
      @composer = XTeamSchedule::Composer.new(schedule)
    end

    it 'creates a correspoding colour hash' do
      @composer.send(:compose_colour, { :red => 0.1, :green => 0.2, :blue => 0.3 }).
        should == { 'alpha' => 1, 'red' => 0.1, 'green' => 0.2, 'blue' => 0.3 }
    end
  end

  describe '#compose_date' do
    before do
      schedule = XTeamSchedule::Schedule.create!
      @composer = XTeamSchedule::Composer.new(schedule)
    end

    it 'creates corresponding date strings' do
      @composer.send(:compose_date, Date.new(2000, 01, 20)).should == '01/20/2000'
      @composer.send(:compose_date, Date.new(1990, 12, 10)).should == '12/10/1990'
      @composer.send(:compose_date, Date.new(2010, 06, 07)).should == '06/07/2010'
    end
  end

  describe '#compose_time' do
    before do
      schedule = XTeamSchedule::Schedule.create!
      @composer = XTeamSchedule::Composer.new(schedule)
    end

    it 'creates corresponding time integers' do
      @composer.send(:compose_time, '00:00').should == 0
      @composer.send(:compose_time, '16:40').should == 1000
      @composer.send(:compose_time, '20:34').should == 1234
    end
  end
end
