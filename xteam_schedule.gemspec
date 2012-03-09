Gem::Specification.new do |s|
  s.name        = 'xteam_schedule'
  s.version     = '0.0.3'
  s.date        = '2012-02-15'
  s.summary     = 'XTeam Schedule'
  s.description = "Full control over schedules for use with adnX's xTeam software"
  s.author      = 'Christopher Patuzzo'
  s.email       = 'chris.patuzzo@gmail.com'
  s.files       =  ['README.md'] + Dir['lib/**/*.*']
  s.homepage    = 'https://github.com/cpatuzzo/xteam_schedule'
  
  s.add_dependency 'plist'
  s.add_dependency 'activerecord', '>= 2.2.2'
  s.add_dependency 'sqlite3'
  
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'factory_girl', '2.2.0'
  s.add_development_dependency 'database_cleaner'
end
