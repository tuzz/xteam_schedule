require 'xteam_schedule/core'
require 'xteam_schedule/io'
require 'xteam_schedule/db'
require 'xteam_schedule/resource_group'
require 'xteam_schedule/resource'

XTeamSchedule::DB.connect
XTeamSchedule::DB.build_schema