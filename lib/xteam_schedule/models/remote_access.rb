class XTeamSchedule::RemoteAccess < XTeamSchedule::Base
  belongs_to :schedule

  validate :format_of_name
  NAME_REGEX = /XTEAM-\d{8}-\d{4}/.freeze

private

  def format_of_name
    return unless name
    raise 'invalid' unless name =~ NAME_REGEX
    xteam, date, time = name.split('-')
    day, month, year = date[0..1], date[2..3], date[4..7]
    hour, minute = time[0..1], time[2..3]
    DateTime.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i)
  rescue
    errors.add(:name, 'is not in the form XTEAM-DDMMYYYY-HHMM')
  end

end
