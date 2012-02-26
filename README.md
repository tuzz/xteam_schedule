## Introduction

xTeam Schedule is a gem that provides full control over schedules for use with [adnX's xTeam](http://www.adnx.com/i/apps/xteam4mac) software.

It is capable of reading and writing schedules, whilst providing access to all of its components through the [ActiveRecord](http://api.rubyonrails.org/classes/ActiveRecord/Base.html) interface, which every Ruby on Rails developer will be familiar with. This is absolutely, **the best solution** for managing agile teams.

<img src="http://www.adnx.com/i/uploads/xTeam1.jpg" width="820" alt="xTeam Schedule" />

### Features:

* **Read and write schedules** and interact with in-memory models through the ActiveRecord interface
* **Customise everything**; resources, assignments, groups, holidays, absences, iPhone sync settings..
* **Intuitive naming** of models, that correspond to what you see on screen
* **Full test coverage**, giving confidence to highly dynamic businesses everywhere

### Disclaimer

I am in no way associated with adnX. I work for an agile development company that makes use of xTeam. This project is open-source.

## Getting Started

It is not required that you have [xTeam](http://www.adnx.com/i/apps/xteam4mac) installed. However, you will not be able to visualise your schedules otherwise.

**Install the gem:**

    gem install xteam_schedule

**Require it in your project:**

    require 'xteam_schedule'

You may need to require 'rubygems' too, if you are running an old version of Ruby.

**Create a Schedule**

You can create a new schedule, or read one from a file:

    schedule = XTeamSchedule.new
    schedule = XTeamSchedule.new('path/to/file.xtps')

## Schedules

Schedules are the top level model through which you access everything. The inspect method is custom-made to give you an overview of the contents of the schedule:

    XTeamSchedule.new('path/to/file.xtps')
    => #<XTeamSchedule resoruce_groups(9), resources(42), assignment_groups(14), assignments(118), working_times(79)>

A schedule has many resource groups and assignment groups. It also has many resources and assignments through resource groups and assignment groups respectively. Finally, a schedule has many working times through either resource groups then resources or assignment groups then assignments.

    schedule = XTeamSchedule.new('path/to/file.xtps')

    resource_groups   = schedule.resource_groups
    resources         = schedule.resources             # or schedule.resource_groups.map(&:resources).flatten
    assignment_groups = schedule.assignment_groups
    assignments       = schedule.assignments
    working_times     = schedule.working_times

There are numerous other models, for example a schedule has one 'interface' which contains various display settings. These are explained in detail below.

## Resource Groups

Resource groups contain resources. Typical names for resource groups might be 'Management', 'Sales', or 'Developers'.

    schedule.resource_groups.create!(
      :name => 'Management',
      :expanded_in_library => true
    )

**Required attributes:**
name

**Defaults:**
expanded&#95;in&#95;library => true

**Examples queries:**

    resource_groups = schedule.resource_groups
    
    number_of_groups  = resource_groups.count
    junior_developers = resource_groups.find_by_name('Junior Developers').resources
    developer_groups  = resource_groups.where('name like "%developer%"')

## Resources

A resource is an employee. A resource can not be in multiple resource groups.

    developers = schedule.resource_groups.create!(:name => 'Developers')
    developers.resources.create!(
      :name => 'Christopher Patuzzo',
      :email => 'chris@example.com',
      :mobile => '0123456789',
      :phone => '9876543210',
      :displayed_in_planning => true
    )

**Required attributes:**
name

**Defaults:**
displayed&#95;in&#95;planning => true

**Example queries:**

    resource_groups = schedule.resource_groups
    resources       = resource_groups.resources
    
    chris_mobile         = resources.find_by_name('Christopher Patuzzo').mobile
    gmail_resource_names = resources.where('email like "%gmail%"').map(&:name)
    resources.each { |r| r.update_attribute(:displayed_in_planning, true) }

## Assignment Groups

Assignment groups are almost identical to resource groups. Typical names might be 'Training' and 'Research'.

    schedule.assignment_groups.create!(
      :name => 'Training',
      :expanded_in_library => true
    )

**Required attributes:**
name

**Defaults:**
expanded&#95;in&#95;library => true

**Example queries:**

    assignment_groups = schedule.assignment_groups
    
    final_group_name         = assignment_groups.last.name
    expanded_groups          = assignment_groups.where(:expanded_in_library => true)
    visible_assignment_count = expanded_groups.map(&:assignments).map(&:count).inject(:+)

## Contribution

Please feel free to contribute, either through pull requests or feature requests here on Github.

For news and latest updates, follow me on Twitter ([@cpatuzzo](https://twitter.com/#!/cpatuzzo)).