require 'plist'

class XTeamSchedule::IO
  
  def self.read(filename)
    Plist.parse_xml(filename)
  end
  
  def self.write(hash, filename)
    hash.save_plist(filename)
  end
  
end
