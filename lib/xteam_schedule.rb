require 'active_record'
require 'plist'

require 'xteam_schedule/core'
require 'xteam_schedule/io'
require 'xteam_schedule/db'
require 'xteam_schedule/resource_group'
require 'xteam_schedule/resource'
require 'xteam_schedule/assignment_group'
require 'xteam_schedule/assignment'

XTeamSchedule::DB.connect
XTeamSchedule::DB.build_schema
