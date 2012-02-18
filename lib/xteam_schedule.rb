require 'plist'
require 'active_record'
require 'sqlite3'

require 'xteam_schedule/models/xteam_schedule'
require 'xteam_schedule/models/resource_group'
require 'xteam_schedule/models/resource'
require 'xteam_schedule/models/assignment_group'
require 'xteam_schedule/models/assignment'

require 'xteam_schedule/facilitation/io'
require 'xteam_schedule/facilitation/db'

XTeamSchedule::DB.connect
XTeamSchedule::DB.build_schema
