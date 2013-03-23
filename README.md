## Introduction

xTeam Schedule is a gem that provides full control over schedules for use with [adnX's xTeam](http://www.adnx.com/i/apps/xteam4mac) software.

It is capable of reading and writing schedules, whilst providing access to all of its components through the [ActiveRecord](http://api.rubyonrails.org/classes/ActiveRecord/Base.html) interface, which every Ruby on Rails developer will be familiar with. This is absolutely, **the best solution** for managing agile teams.

You can find a blog post explaining some of the thinking behind its implementation [here](https://www.unboxedconsulting.com/blog/gemnastics-with-activerecord).

<img src="http://www.adnx.com/i/uploads/xTeam1.jpg" width="820" alt="xTeam Schedule" />

### Features:

* **Read and write schedules** and interact with in-memory models through the ActiveRecord interface
* **Customise everything**; resources, assignments, groups, colours, holidays, remote access..
* **Intuitive naming** of models, that correspond to what you see on screen
* **Full test coverage**, giving confidence to highly dynamic businesses everywhere [![Build Status](https://secure.travis-ci.org/tuzz/xteam_schedule.png?branch=master)](http://travis-ci.org/tuzz/xteam_schedule)

### Disclaimer

I am in no way associated with adnX. I work for an agile development company that makes use of xTeam. This project is open-source.

## Getting Started

It is not required that you have [xTeam](http://www.adnx.com/i/apps/xteam4mac) installed. However, you will not be able to visualise your schedules otherwise.

**Install the gem:**

```ruby
gem install xteam_schedule
```

**Require it in your project:**

```ruby
require 'xteam_schedule'
```

You may need to require 'rubygems' too, if you are running an old version of Ruby.

**Create a Schedule**

You can create a new schedule, or read one from a file:

```ruby
schedule = XTeamSchedule.new
schedule = XTeamSchedule.new('path/to/file.xtps')
```

## Schedules

Schedules are the top level model through which you access everything. The inspect method is custom-made to give you an overview of the contents of the schedule:

```ruby
XTeamSchedule.new('path/to/file.xtps')
=> #<XTeamSchedule resoruce_groups(9), resources(42), assignment_groups(14), assignments(118), working_times(79)>
```

A schedule has many resource groups and assignment groups. It also has many resources and assignments through resource groups and assignment groups respectively. Finally, a schedule has many working times through either resource groups then resources or assignment groups then assignments. Wherever possible, naming has been chosen to match xTeam, i.e. 'resource' instead of 'employee'.

```ruby
schedule = XTeamSchedule.new('path/to/file.xtps')

resource_groups   = schedule.resource_groups
resources         = schedule.resources         # or schedule.resource_groups.map(&:resources).flatten
assignment_groups = schedule.assignment_groups
assignments       = schedule.assignments
working_times     = schedule.working_times
```

There are numerous other models, for example a schedule has one 'interface' which contains various display settings. These are explained in detail below. To output a schedule that can be read by xTeam, use the 'write' method:

```ruby
schedule.write('path/to/file.xtps')
```

 It is also possible to convert a schedule to/from a hash. After serialisation, this could easily be written to a database.

```ruby
hash     = schedule.hash
schedule = XTeamSchedule.new(hash)
```

## Resource Groups

Resource groups contain resources. Typical names for resource groups might be 'Management', 'Sales', or 'Developers'.

```ruby
schedule.resource_groups.create!(
  :name => 'Management',
  :expanded_in_library => true
)
```

**Required attributes:**
name

**Defaults:**
expanded_in_library => true

**Examples queries:**

```ruby
resource_groups = schedule.resource_groups

number_of_groups  = resource_groups.count
junior_developers = resource_groups.find_by_name('Junior Developers').resources
developer_groups  = resource_groups.where('name like "%developer%"')
```

## Resources

A resource is an employee. A resource can not be in multiple resource groups.

```ruby
developers = schedule.resource_groups.create!(:name => 'Developers')
developers.resources.create!(
  :name => 'Christopher Patuzzo',
  :email => 'chris@example.com',
  :mobile => '0123456789',
  :phone => '9876543210',
  :displayed_in_planning => true
)
```

**Required attributes:**
name

**Defaults:**
displayed_in_planning => true

**Example queries:**

```ruby
resources = schedule.resources

chris_mobile         = resources.find_by_name('Christopher Patuzzo').mobile
gmail_resource_names = resources.where('email like "%gmail%"').map(&:name)
resources.each { |r| r.update_attribute(:displayed_in_planning, true) }
```

A resource also has remote access attributes, that are explained below.

## Assignment Groups

Assignment groups are almost identical to resource groups. Typical names might be 'Training' and 'Research'.

```ruby
schedule.assignment_groups.create!(
  :name => 'Training',
  :expanded_in_library => true
)
```

**Required attributes:**
name

**Defaults:**
expanded_in_library => true

**Example queries:**

```ruby
assignment_groups = schedule.assignment_groups

final_group_name         = assignment_groups.last.name
expanded_groups          = assignment_groups.where(:expanded_in_library => true)
visible_assignment_count = expanded_groups.map(&:assignments).map(&:count).inject(:+)
```

## Assignments

An assignment is a task. An assignment cannot be in multiple assignment groups.

```ruby
training = schedule.assignment_groups.create!(:name => 'Training')
training.assignments.create!(
  :name => 'Rails Conference',
  :colour => { :red => 1, :green => 0, :blue => 0 }
)
```

**Required attributes:**
name

**Defaults:**
colour => { :red => 0.5, :green => 0.5, :blue => 0.5 }

**Aliases:**
color => colour

**Example queries:**

```ruby
assignments = schedule.assignments

rails_assignments       = assignments.where('name like "%rails%"')
first_assignment_colour = assignments.first.colour
singleton_assignments   = assignments.select { |a| a.assignment_group.assignments.count == 1 }
```

## Working Times

A working time is a relationship between a resource and an assignment. This is equivalent to scheduling an employee on a specific task for a given duration. Assignments are assigned to resources by creating working times.

```ruby
developers        = schedule.resource_groups.create!(:name => 'Developers')
chris             = developers.resources.create!(:name => 'Christopher Patuzzo')

channel_5         = schedule.assignment_groups.create!(:name => 'Channel 5')
the_gadget_show   = channel_5.assignments.create!(:name => 'The Gadget Show')

chris.working_times.create!(
  :assignment => the_gadget_show,
  :begin_date => Date.new(2012, 01, 01),
  :duration => 20,
  :notes => 'Based in London'
)
```

The creation can also be written from the assignment, or directly from the model:

```ruby
the_gadget_show.working_times.create!(
  :resource => chris,
  # etc.
)

XTeamSchedule::WorkingTime.create!(
  :resource => chris,
  :assignment => the_gadget_show,
  # etc.
)
```

**Required attributes:**
begin_date, duration

**Example queries:**

```ruby
working_times = schedule.working_times

maximum_duration          = working_times.map(&:duration).max.to_s + ' days'
recent_working_times      = working_times.where('begin_date > ?', Date.new(2012, 01, 01))
resources_on_new_projects = recent_working_times.map(&:resource).uniq.map(&:name)
```

## Interface

A schedule has one interface that is created automatically. The interface is responsible for the display settings of xTeam. Possible values to pass to the granularities constant are: :day, :week, :month and :year

```ruby
schedule.interface.update_attributes!(
  :display_assignments_name => true,
  :display_resources_name => false,
  :display_working_hours => false,
  :display_resources_pictures => true,
  :display_total_of_working_hours => false,
  :display_assignments_notes => true,
  :display_absences => true,
  :time_granularity => XTeamSchedule::Interface::TIME_GRANULARITIES[:month]
)
```

**Defaults:**
The same as the attributes shown above.

**Aliases:**

```ruby
display_assignment_names    => display_assignments_name
display_resource_names      => display_resources_name
display_resource_pictures   => display_resources_pictures
display_total_working_hours => display_total_of_working_hours
display_assignment_notes    => display_assignments_notes
```

## Weekly Working Schedule

The weekly working schedule determines the 'opening hours' of the company. Working days can be accessed directly, or through weekly_working_schedule.

```ruby
# Set all days to start at 9am, and finish at 5pm
# Set a lunch break from 12pm - 1pm each day
working_days = schedule.working_days
working_days.each do |day|
  day.update_attributes!(
    :day_begin   => '09:00',
    :day_end     => '17:00',
    :break_begin => '12:00',
    :break_end   => '13:00'
  )
end
```

Non working days are determined by setting the 'day_begin' attribute to nil. This works similarly for days without lunch breaks:

```ruby
wednesday = working_days.find_by_name('Wednesday')
saturday = working_days.find_by_name('Saturday')
sunday = working_days.find_by_name('Sunday')

[saturday, sunday].each { |day| day.update_attributes!(:day_begin => nil) }
wednesday.update_attribute(:break_begin, nil)
```

**Defaults:**
The default weekly working schedule is identical to the one set up above (except wednesday lunch). i.e. 9am-5pm Mon-Fri, with lunch from 12pm-1pm.

## Holidays

Holidays can either belong to a resource, or the entire schedule. Holidays on the schedule are shared by all resources. This is useful for bank holidays. You can leave off the end date for one day holidays.

```ruby
schedule.holidays.create!(:begin_date => Date.new(2012, 12, 25), :name => 'Christmas Day')

resource_group = schedule.resource_groups.create(:name => 'foo')
resource = resource_group.resources.create!(:name => 'bar')
resource.holidays.create!(
  :begin_date => Date.new(2012, 07, 01),
  :end_date => Date.new(2012, 07, 10),
  :name => 'Visiting California'
)
```

**Required attributes:**
begin_date

**Example queries:**

```ruby
holiday_names = schedule.resources.map(&:holidays).flatten.map(&:name)
resources_without_holidays = schedule.resources.select { |r| r.holidays.empty? }
finished_holidays = schedule.resources.map(&:holidays).flatten.select { |h|
  (h.end_date || h.begin_date) < Date.today
}
```

## Remote Access

Remote access allows the xTeamView application on Mac OS X and iOS devices to view schedules remotely. A schedule has a remote_access object containing most of the setup, including the 'All' login option for the schedule.

```ruby
schedule.remote_access.update_attributes!(
  :enabled => true,
  :custom_url => 'http://xteambridge.example.com',
  :custom_enabled => true,
  :global_login => 'username',
  :global_password => 'password',
  :global_login_enabled => true
)
```

When remote access is switched on in xTeam, there is a handshake process that takes place which assigns a server_id and name to the schedule. If either of these is missing or they become out of sync, the handshake will fail and you will be notified of an error in xTeam. Therefore, it is recommended that you do not change these attributes. Instead, you should enable remote in xTeam then read these attributes from that file. You can then re-use them as you please.

```ruby
schedule = XTeamSchedule.new('path/to/file/with/remote/enabled.xtps')
server_id = schedule.remote_access.server_id
name = schedule.remote_access.name

# An example of re-using the remote configuration for an entirely new schedule
schedule = XTeamSchedule.new
schedule.remote_access.update_attributes!(
  :server_id => server_id,
  :name => name
)
```

There are three additional attributes on each resource for configuring individual logins. It is worth noting that login details have to be plaintext, unfortunately.

```ruby
resource_group = schedule.resource_groups.create(:name => 'foo')
resource = resource_group.resources.create!(
  :name => 'bar',
  :remote_login => 'bar',
  :remote_password => 'baz',
  :remote_login_enabled => true
)
```

**Example queries:**

```ruby
global_login_details = [schedule.remote_access.global_login, schedule.remote_access.global_password]
resources_without_logins = schedule.resources.reject { |r| r.remote_login }
usernames = schedule.resources.map(&:remote_login).compact
raise 'There are duplicated logins' if usernames.count > usernames.uniq.count
```

## Under Development

This gem is far from complete. The following is a list of features that are under development, somewhat in priority order:

* Filtering and custom placement (dropdown)
* To assign (the drag 'n' drop box)
* Absences (holidays, minus the fun)
* Resource images (spike - need to work out what)
* Tiny interface things (hiding things, column widths)
* Schedule splicing before / after / between dates
* Binary operators (addition / subtraction of two schedules)
* Documentation overhaul (code docs, sectioned GitHub?)
* File system hooks (unobtrusive file diffs)
* A built in example (xTeam has one, we can too)
* Report generation (xTeam's suck, make something better)
* Improved colour controls (0-255, 0-1, hex, group inheritance)
* Date helpers (either end date, or number of days)

## Contribution

Please feel free to contribute, either through pull requests or feature requests here on Github.

For news and latest updates, follow me on Twitter ([@cpatuzzo](https://twitter.com/#!/cpatuzzo)).
