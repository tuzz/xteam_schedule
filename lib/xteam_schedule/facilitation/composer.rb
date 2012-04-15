class XTeamSchedule::Composer

  attr_accessor :schedule, :hash

  def self.compose(schedule)
    new(schedule).compose
  end

  def initialize(schedule)
    schedule.save!
    self.schedule = schedule
    self.hash = HashWithoutNilValues.new
  end

  def compose
    compose_resource_groups!
    compose_resources!
    compose_assignment_groups!
    compose_assignments!
    compose_working_times!
    compose_interface!
    compose_weekly_working_schedule!
    compose_holidays!
    compose_remote_access!
    compose_schedule!
    hash
  end

private

  def compose_resource_groups!
    hash['resource groups'] ||= []
    resource_groups = schedule.resource_groups
    resource_groups.each do |rg|
      hash['resource groups'] << {}
      current = hash['resource groups'].last
      current['name'] = rg.name
      current['expanded in library'] = rg.expanded_in_library
    end
  end

  def compose_resources!
    hash['resources'] ||= []
    resources = schedule.resource_groups.map(&:resources).flatten
    resources.each do |r|
      image = Base64.decode64(r.image) if r.image
      hash['resources'] << {}
      current = hash['resources'].last
      current['displayedInPlanning'] = r.displayed_in_planning
      current['email'] = r.email
      current['image'] = (StringIO.new(image) if image)
      current['mobile'] = r.mobile
      current['name'] = r.name
      current['phone'] = r.phone
      current['group'] = r.resource_group.name
    end
  end

  def compose_assignment_groups!
    hash['task categories'] ||= []
    assignment_groups = schedule.assignment_groups
    assignment_groups.each do |ag|
      hash['task categories'] << {}
      current = hash['task categories'].last
      current['name'] = ag.name
      current['expanded in library'] = ag.expanded_in_library
    end
  end

  def compose_assignments!
    hash['tasks'] ||= []
    assignments = schedule.assignment_groups.map(&:assignments).flatten
    assignments.each do |a|
      hash['tasks'] << {}
      current = hash['tasks'].last
      current['name'] = a.name
      current['category'] = a.assignment_group.name
      current['kind'] = 0
      current['color'] = compose_colour(a.colour)
    end
  end

  def compose_working_times!
    hash['objectsForResources'] ||= {}
    resources = schedule.resource_groups.map(&:resources).flatten
    resources.each do |r|
      working_times_with_parents = r.working_times.select { |wt| wt.resource and wt.assignment }
      next unless working_times_with_parents.any?
      hash['objectsForResources'][r.name] = []
      working_times_with_parents.each do |wt|
        hash['objectsForResources'][r.name] << {}
        current = hash['objectsForResources'][r.name].last
        current['task'] = wt.assignment.name
        current['begin date'] = compose_date(wt.begin_date)
        current['duration'] = wt.duration
        current['notes'] = wt.notes
        current['title'] = ''
      end
    end
  end

  def compose_interface!
    interface = schedule.interface
    hash['display task names'] = interface.display_assignments_name
    hash['display resource names'] = interface.display_resources_name
    hash['display worked time'] = interface.display_working_hours
    hash['display resource icons'] = interface.display_resources_pictures
    hash['display resource totals'] = interface.display_total_of_working_hours
    hash['display task notes'] = interface.display_assignments_notes
    hash['display absence cells'] = interface.display_absences
    hash['interface status'] ||= {}
    hash['interface status']['latest time navigation mode'] = interface.time_granularity
  end

  def compose_weekly_working_schedule!
    weekly_working_schedule = schedule.weekly_working_schedule
    working_days = weekly_working_schedule.working_days

    hash['settings'] ||= {}
    hash['settings']['days off'] ||= []
    hash['settings']['working schedule'] ||= {}

    working_days.each do |day|
      day_name = day.name.downcase
      hash['settings']['working schedule'][day_name] = {}
      current = hash['settings']['working schedule'][day_name]
      if day.day_begin.present?
        current['worked'] = 'yes'
        current['begin'] = compose_time(day.day_begin)
        current['end'] = compose_time(day.day_end)
      else
        current['worked'] = 'no'
      end

      hash['settings']['working schedule']["pause_#{day_name}"] = {}
      current = hash['settings']['working schedule']["pause_#{day_name}"]
      if day.day_begin.present? and day.break_begin.present?
        current['worked'] = 'yes'
        current['begin'] = compose_time(day.break_begin)
        current['end'] = compose_time(day.break_end)
        current['duration'] = compose_time(day.break_end) - compose_time(day.break_begin)
      end
    end
  end

  def compose_holidays!
    compose_schedule_holidays!
    compose_resource_holidays!
  end

  def compose_schedule_holidays!
    holidays = schedule.holidays

    hash['settings'] ||= {}
    hash['settings']['days off'] ||= []

    holidays.each do |h|
      h.end_date ||= h.begin_date
      hash['settings']['days off'] << {}
      current = hash['settings']['days off'].last
      current['begin date'] = compose_date(h.begin_date)
      current['end date'] = compose_date(h.end_date)
      current['name'] = h.name
    end
  end

  def compose_resource_holidays!
    resources = schedule.resource_groups.map(&:resources).flatten
    resources.each do |r|
      next unless r.holidays
      index = hash['resources'].find_index { |h| h['name'] == r.name }
      next unless index

      hash['resources'][index]['settings'] ||= {}
      hash['resources'][index]['settings']['days off'] ||= []
      hash['resources'][index]['settings']['use custom days off'] = 1
      r.holidays.each do |h|
        h.end_date ||= h.begin_date
        hash['resources'][index]['settings']['days off'] << {}
        current = hash['resources'][index]['settings']['days off'].last
        current['begin date'] = compose_date(h.begin_date)
        current['end date'] = compose_date(h.end_date)
        current['name'] = h.name
      end
    end
  end

  def compose_remote_access!
    remote_access = schedule.remote_access
    hash['settings'] ||= {}

    valid_setup = remote_access.server_id && remote_access.name
    enable = valid_setup && remote_access.enabled

    hash['settings']['remoteId'] = remote_access.server_id if valid_setup
    hash['settings']['remoteEnable'] = enable
    hash['settings']['remoteName'] = remote_access.name if valid_setup
    hash['settings']['remoteCustomServerURL'] = remote_access.custom_url
    hash['settings']['remoteUseCustomServer'] = remote_access.custom_enabled

    if remote_access.global_login or remote_access.global_password
      hash['settings']['remoteLoginInfo'] ||= {}
      hash['settings']['remoteLoginInfo']['All'] ||= {}
      hash['settings']['remoteLoginInfo']['All']['login'] = remote_access.global_login
      hash['settings']['remoteLoginInfo']['All']['password'] = remote_access.global_password
      hash['settings']['remoteLoginInfo']['All']['enable'] = remote_access.global_login_enabled
    end

    compose_remote_access_for_resources!
  end

  def compose_remote_access_for_resources!
    hash['settings'] ||= {}
    hash['settings']['remoteLoginInfo'] ||= {}

    schedule.resources.each do |r|
      hash['settings']['remoteLoginInfo'][r.name] = {}
      hash['settings']['remoteLoginInfo'][r.name]['login'] = r.remote_login
      hash['settings']['remoteLoginInfo'][r.name]['password'] = r.remote_password
      hash['settings']['remoteLoginInfo'][r.name]['enable'] = r.remote_login_enabled
    end
  end

  def compose_schedule!
    hash['begin date'] = compose_date(schedule.begin_date)
    hash['end date'] = compose_date(schedule.end_date)
  end

  def compose_colour(colour_hash)
    { 'alpha' => 1 }.merge([:red, :green, :blue].inject({}) { |h, c| h[c.to_s] = colour_hash[c]; h })
  end

  def compose_date(date)
    return unless date.present?
    components = []
    components << ("%02d" % date.month)
    components << ("%02d" % date.day)
    components << date.year
    components.join('/')
  end

  def compose_time(time_string)
    return unless time_string.present?
    hours, minutes = time_string.split(':').map(&:to_i)

    hours * 60 + minutes
  end
end
