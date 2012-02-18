require 'plist'
require 'active_record'
require 'sqlite3'
require 'xteam_schedule/core'

Dir['lib/**/*.*'].each { |f| require f }

XTeamSchedule::DB.connect
XTeamSchedule::DB.build_schema
