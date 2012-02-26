class XTeamSchedule
  
  def initialize(filename = nil)
    if filename.present?
      begin
        hash = IO.read(filename)
        @schedule = Parser.parse(hash)
      rescue
        raise 'Malformed xTeam Schedule file'
      end
    else
      @schedule = Schedule.new
    end
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
