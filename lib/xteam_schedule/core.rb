class XTeamSchedule
  
  def initialize(hash_or_filename = nil)
    if hash_or_filename.present?
      hash = hash_or_filename.class == Hash ? hash_or_filename : IO.read(hash_or_filename)
      @schedule = Parser.parse(hash)
    else
      @schedule = Schedule.create!
    end
  end
  
  def write(filename)
    raise 'No filename provided' unless filename.present?
    IO.write(hash, filename)
  end
  
  def hash
    Composer.compose(self)
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
