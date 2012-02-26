class XTeamSchedule
  
  def initialize(filename = nil)
    if filename.present?
      hash = IO.read(filename)
      @schedule = Parser.parse(hash)
    else
      @schedule = Schedule.create!
    end
  end
  
  def write(filename)
    raise 'No filename provided' unless filename.present?
    hash = Composer.compose(self)
    IO.write(hash, filename)
  end
  
  def method_missing(*args);
    @schedule.send(*args)
  end
  
  def inspect
    stats = [:resource_groups, :resources, :assignment_groups, :assignments, :working_times].map { |s| [s, send(s).count] }
    stats_string = stats.map { |s| "#{s.first}(#{s.second})" }.join(', ')
    "#<XTeamSchedule #{stats_string}>"
  end
  
end
