Gem::Specification.new do |s|
  s.name        = 'xteam_schedule'
  s.version     = '0.0.1'
  s.date        = '2012-02-15'
  s.summary     = 'XTeam Schedule'
  s.description = "Read and write schedules for use with adnx's XTeam software"
  s.author      = 'Christopher Patuzzo'
  s.email       = 'chris.patuzzo@gmail.com'
  s.files       = ['README.md', 'lib/xteam_schedule.rb', 'lib/xteam_schedule/core.rb', 'lib/xteam_schedule/io.rb', 'lib/xteam_schedule/db.rb', 'lib/xteam_schedule/resource_group.rb']
  s.homepage    = 'https://github.com/cpatuzzo/xteam_schedule'
  
  s.add_dependency 'plist'
  s.add_dependency 'activerecord'
  s.add_dependency 'sqlite3'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'factory_girl'
end
