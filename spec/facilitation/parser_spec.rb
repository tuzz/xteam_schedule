require 'spec_helper'

describe XTeamSchedule::Parser do

  def color_hash(factor = 1)
    { 'alpha' => 1, 'red' => 0.1 * factor, 'green' => 0.2 * factor, 'blue' => 0.3 * factor }
  end

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

    it 'calls parse_interface!' do
      @parser.should_receive(:parse_interface!)
      @parser.parse
    end

    it 'calls parse_weekly_working_schedule!' do
      @parser.should_receive(:parse_weekly_working_schedule!)
      @parser.parse
    end

    it 'calls parse_holidays!' do
      @parser.should_receive(:parse_holidays!)
      @parser.parse
    end

    it 'calls parse_schedule!' do
      @parser.should_receive(:parse_schedule!)
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
        'resource groups' => [{ 'name' => 'foo' }],
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
      image = Base64.encode64('image')
      XTeamSchedule::Resource.find_by_image(image).should_not be_nil
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
        { 'name' => 'foo', 'expanded in library' => true, 'color' => color_hash },
        { 'name' => 'bar', 'expanded in library' => false, 'color' => color_hash  }
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
        'tasks' => [{ 'category' => 'foo', 'name' => 'bar', 'color' => color_hash },
                    { 'category' => 'baz', 'name' => 'quux', 'color' => color_hash }]
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

    it 'sets the colour attribute correctly' do
      @parser.send(:parse_assignments!)
      XTeamSchedule::Assignment.first.colour.should == { :red => 0.1, :green => 0.2, :blue => 0.3 }
    end
  end

  describe '#parse_working_times!' do
    before do
      @hash = {
        'resource groups' => [{ 'name' => 'foo' }],
        'task categories' => [{ 'name' => 'bar' }],
        'resources' => [{ 'name' => 'baz', 'group' => 'foo' }],
        'tasks' => [{ 'name' => 'quux', 'category' => 'bar', 'color' => color_hash }],
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

  describe '#parse_interface!' do
    before do
      @hash = {
        'display task names'      => false,
        'display resource names'  => true,
        'display worked time'     => true,
        'display resource icons'  => false,
        'display resource totals' => true,
        'display task notes'      => false,
        'display absence cells'   => false,
        'interface status' => { 'latest time navigation mode' => XTeamSchedule::Interface::TIME_GRANULARITIES[:day] }
      }
      @parser = XTeamSchedule::Parser.new(@hash)
    end

    it 'sets the display_assignments_name attribute correctly' do
      @parser.send(:parse_interface!)
      XTeamSchedule::Interface.find_by_display_assignments_name(false).should_not be_nil
    end

    it 'sets the display_resources_name attribute correctly' do
      @parser.send(:parse_interface!)
      XTeamSchedule::Interface.find_by_display_resources_name(true).should_not be_nil
    end

    it 'sets the display_working_hours attribute correctly' do
      @parser.send(:parse_interface!)
      XTeamSchedule::Interface.find_by_display_working_hours(true).should_not be_nil
    end

    it 'sets the display_resources_pictures attribute correctly' do
      @parser.send(:parse_interface!)
      XTeamSchedule::Interface.find_by_display_resources_pictures(false).should_not be_nil
    end

    it 'sets the display_total_of_working_hours attribute correctly' do
      @parser.send(:parse_interface!)
      XTeamSchedule::Interface.find_by_display_total_of_working_hours(true).should_not be_nil
    end

    it 'sets the display_assignments_notes attribute correctly' do
      @parser.send(:parse_interface!)
      XTeamSchedule::Interface.find_by_display_assignments_notes(false).should_not be_nil
    end

    it 'sets the display_absences attribute correctly' do
      @parser.send(:parse_interface!)
      XTeamSchedule::Interface.find_by_display_absences(false).should_not be_nil
    end

    it 'sets the time_granularity attribute correctly' do
      @parser.send(:parse_interface!)
      day_granularity = XTeamSchedule::Interface::TIME_GRANULARITIES[:day]
      XTeamSchedule::Interface.find_by_time_granularity(day_granularity).should_not be_nil
    end
  end

  describe '#parse_weekly_working_schedule!' do
    before do
      @hash = { 'settings' => { 'working schedule' => {
        'monday' => { 'begin' => 0, 'end' => 600, 'worked' => 'yes' },
        'pause_monday' => { 'begin' => 300, 'duration' => 60, 'end' => 360, 'worked' => 'yes' },
        'tuesday' => { 'begin' => 600, 'end' => 720, 'worked' => 'yes' },
        'pause_tuesday' => { 'worked' => 'no' },
        'saturday' => { 'worked' => 'no' },
        'pause_saturday' => {}
      }}}
      @parser = XTeamSchedule::Parser.new(@hash)
    end

    it 'creates working days' do
      @parser.send(:parse_weekly_working_schedule!)
      XTeamSchedule::WorkingDay.count.should_not be_zero
    end

    it 'creates working days from scratch' do
      wednesday = XTeamSchedule::WorkingDay.find_by_name('Wednesday')
      @parser.send(:parse_weekly_working_schedule!)
      XTeamSchedule::WorkingDay.find_by_name('Wednesday').should_not equal wednesday
    end

    it 'sets the name attribute correctly' do
      @parser.send(:parse_weekly_working_schedule!)
      XTeamSchedule::WorkingDay.find_by_name('Monday').should_not be_nil
    end

    it 'sets the day_begin attribute correctly' do
      @parser.send(:parse_weekly_working_schedule!)
      XTeamSchedule::WorkingDay.find_by_day_begin('00:00').should_not be_nil
    end

    it 'sets the day_end attribute correctly' do
      @parser.send(:parse_weekly_working_schedule!)
      XTeamSchedule::WorkingDay.find_by_day_end('10:00').should_not be_nil
    end

    it 'sets the break_begin attribute correctly' do
      @parser.send(:parse_weekly_working_schedule!)
      XTeamSchedule::WorkingDay.find_by_break_begin('05:00').should_not be_nil
    end

    it 'sets the break_end attribute correctly' do
      @parser.send(:parse_weekly_working_schedule!)
      XTeamSchedule::WorkingDay.find_by_break_end('06:00').should_not be_nil
    end

    it 'sets non-working days to have a nil day_begin attribute' do
      @parser.send(:parse_weekly_working_schedule!)
      XTeamSchedule::WorkingDay.find_by_name('Saturday').day_begin.should be_nil
      XTeamSchedule::WorkingDay.find_by_name('Sunday').day_begin.should be_nil
    end

    it 'skips breaks correctly' do
      @parser.send(:parse_weekly_working_schedule!)
      XTeamSchedule::WorkingDay.find_by_name('Tuesday').break_begin.should be_nil
      XTeamSchedule::WorkingDay.find_by_name('Sunday').break_begin.should be_nil
    end
  end

  describe '#parse_holidays!' do
    before do
      @parser = XTeamSchedule::Parser.new({})
    end

    it 'calls parse_schedule_holidays!' do
      @parser.should_receive(:parse_schedule_holidays!)
      @parser.send(:parse_schedule_holidays!)
    end

    it 'calls parse_resource_holidays!' do
      @parser.should_receive(:parse_resource_holidays!)
      @parser.send(:parse_resource_holidays!)
    end
  end

  describe '#parse_schedule_holidays!' do
    before do
      @hash = { 'settings' => { 'days off' => [
        { 'begin date' => '01/15/2000', 'end date' => '01/16/2000', 'name' => '' },
        { 'begin date' => '02/15/2000', 'end date' => '02/15/2000', 'name' => 'Hol' }
      ]}}
      @parser = XTeamSchedule::Parser.new(@hash)
    end

    it 'creates holidays' do
      @parser.send(:parse_schedule_holidays!)
      XTeamSchedule::Holiday.count.should_not be_zero
    end

    it 'sets the begin date attribute correctly' do
      @parser.send(:parse_schedule_holidays!)
      XTeamSchedule::Holiday.find_by_begin_date(Date.new(2000, 01, 15)).should_not be_nil
    end

    it 'sets the end date attribute correctly' do
      @parser.send(:parse_schedule_holidays!)
      XTeamSchedule::Holiday.find_by_end_date(Date.new(2000, 01, 16)).should_not be_nil
    end

    it 'sets the name attribute correctly' do
      @parser.send(:parse_schedule_holidays!)
      XTeamSchedule::Holiday.find_by_name('Hol').should_not be_nil
    end

    it 'does not set the end date if it matches the begin date' do
      @parser.send(:parse_schedule_holidays!)
      XTeamSchedule::Holiday.find_by_end_date(Date.new(2000, 02, 15)).should be_nil
      XTeamSchedule::Holiday.count.should == 2
    end
  end

  describe '#parse_resource_holidays!' do
    before do
      @hash = {
        'resource groups' => [{ 'name' => 'foo' }],
        'resources' => [
          { 'group' => 'foo', 'name' => 'bar', 'settings' => { 'days off' => [
            { 'begin date' => '01/15/2000', 'end date' => '01/16/2000', 'name' => '' },
            { 'begin date' => '02/15/2000', 'end date' => '02/15/2000', 'name' => 'Hol' }
          ]}},
          { 'group' => 'foo', 'name' => 'baz', 'settings' => { 'days off' => []}}
        ]
      }
      @parser = XTeamSchedule::Parser.new(@hash)
      @parser.send(:parse_resource_groups!)
      @parser.send(:parse_resources!)
      @resource = XTeamSchedule::Resource.find_by_name('bar')
    end

    it 'creates holidays' do
      @parser.send(:parse_resource_holidays!)
      XTeamSchedule::Holiday.count.should_not be_zero
    end

    it 'sets the begin date attribute correctly' do
      @parser.send(:parse_resource_holidays!)
      @resource.holidays.find_by_begin_date(Date.new(2000, 01, 15)).should_not be_nil
    end

    it 'sets the end date attribute correctly' do
      @parser.send(:parse_resource_holidays!)
      @resource.holidays.find_by_end_date(Date.new(2000, 01, 16)).should_not be_nil
    end

    it 'sets the name attribute correctly' do
      @parser.send(:parse_resource_holidays!)
      @resource.holidays.find_by_name('Hol').should_not be_nil
    end

    it 'does not set the end date if it matches the begin date' do
      @parser.send(:parse_resource_holidays!)
      @resource.holidays.find_by_end_date(Date.new(2000, 02, 15)).should be_nil
    end
  end

  describe '#parse_schedule!' do
    before do
      @hash = {
        'begin date' => '03/31/2010',
        'end date' => '12/25/2015'
      }
      @parser = XTeamSchedule::Parser.new(@hash)
    end

    it 'sets the begin_date attribute correctly' do
      @parser.send(:parse_schedule!)
      XTeamSchedule::Schedule.find_by_begin_date(Date.new(2010, 03, 31)).should_not be_nil
    end

    it 'sets the end_date attribute correctly' do
      @parser.send(:parse_schedule!)
      XTeamSchedule::Schedule.find_by_end_date(Date.new(2015, 12, 25)).should_not be_nil
    end
  end

  describe '#parse_colour' do
    before do
      @parser = XTeamSchedule::Parser.new({})
    end

    it 'creates a correspoding colour hash' do
      @parser.send(:parse_colour, { 'alpha' => 1, 'red' => 0.1, 'green' => 0.2, 'blue' => 0.3 }).
        should == { :red => 0.1, :green => 0.2, :blue => 0.3 }
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

  describe '#parse_time' do
    before do
      @parser = XTeamSchedule::Parser.new({})
    end

    it 'creates corresponding time strings' do
      @parser.send(:parse_time, 0).should == '00:00'
      @parser.send(:parse_time, 1000).should == '16:40'
      @parser.send(:parse_time, 1234).should == '20:34'
    end
  end

end
