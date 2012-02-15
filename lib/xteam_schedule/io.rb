require 'plist'

class XTeamSchedule::IO
  
  def self.read(filename)
    Plist.parse_xml(filename)
  end
  
end
