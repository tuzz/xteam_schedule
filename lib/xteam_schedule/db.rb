require 'active_record'

class XTeamSchedule::DB
  
  def self.connect
    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database => ':memory:'
    )
  end
  
end
