Gem::Specification.new do |s|
  s.name        = 'xteam_schedule'
  s.version     = '0.2.1'
  s.summary     = 'XTeam Schedule'
  s.description = "Full control over schedules for use with adnX's xTeam software"
  s.author      = 'Chris Patuzzo'
  s.email       = 'chris@patuzzo.co.uk'
  s.files       =  ['README.md'] + Dir['lib/**/*.*']
  s.homepage    = 'https://github.com/tuzz/xteam_schedule'

  s.add_dependency 'plist'
  s.add_dependency 'activerecord', '>= 2.2.2'
  s.add_dependency 'sqlite3'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'factory_girl', '2.2.0'
end
