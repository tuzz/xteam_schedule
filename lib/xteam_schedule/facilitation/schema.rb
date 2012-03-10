class XTeamSchedule::Schema
  
  def self.define(&block)
    instance_eval(&block)
  end
  
  def self.method_missing(method, *args, &block)
    XTeamSchedule::Base.connection.send(method, *args, &block)
  end
  
end
