begin
  require 'yaml'
  YAML::ENGINE.yamler = 'syck'
rescue
end

require 'plist'
require 'active_record'
require 'active_support/multibyte'
require 'sqlite3'
require 'xteam_schedule/core'

require 'xteam_schedule/facilitation/schema'
require 'xteam_schedule/facilitation/base'
require 'xteam_schedule/facilitation/parser'
require 'xteam_schedule/facilitation/composer'
require 'xteam_schedule/facilitation/io'
require 'xteam_schedule/facilitation/lmc_patch'
require 'xteam_schedule/facilitation/qtn_patch'
require 'xteam_schedule/facilitation/without_nil'

require 'xteam_schedule/models/assignment'
require 'xteam_schedule/models/assignment_group'
require 'xteam_schedule/models/interface'
require 'xteam_schedule/models/remote_access'
require 'xteam_schedule/models/resource'
require 'xteam_schedule/models/resource_group'
require 'xteam_schedule/models/schedule'
require 'xteam_schedule/models/weekly_working_schedule'
require 'xteam_schedule/models/working_day'
require 'xteam_schedule/models/working_time'
require 'xteam_schedule/models/holiday'

XTeamSchedule::Base.build_schema
