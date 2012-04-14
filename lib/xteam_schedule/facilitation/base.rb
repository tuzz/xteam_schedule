class XTeamSchedule::Base < ActiveRecord::Base
  self.abstract_class = true
  establish_connection(:adapter => 'sqlite3', :database => ':memory:')

  def self.build_schema
    XTeamSchedule::Schema.define do

      create_table :schedules, :force => true do |table|
        table.column :begin_date, :date, :default => 10.years.ago.to_date
        table.column :end_date, :date, :default => 10.years.from_now.to_date
      end

      create_table :interfaces, :force => true do |table|
        table.column :schedule_id, :integer
        table.column :display_assignments_name, :boolean, :default => true
        table.column :display_resources_name, :boolean, :default => false
        table.column :display_working_hours, :boolean, :default => false
        table.column :display_resources_pictures, :boolean, :default => true
        table.column :display_total_of_working_hours, :boolean, :default => false
        table.column :display_assignments_notes, :boolean, :default => true
        table.column :display_absences, :boolean, :default => true
        table.column :time_granularity, :integer, :default => XTeamSchedule::Interface::TIME_GRANULARITIES[:month]
      end

      create_table :weekly_working_schedules, :force => true do |table|
        table.column :schedule_id, :integer
      end

      create_table :working_days, :force => true do |table|
        table.column :weekly_working_schedule_id, :integer
        table.column :name, :string
        table.column :day_begin, :string
        table.column :day_end, :string
        table.column :break_begin, :string
        table.column :break_end, :string
      end

      create_table :resource_groups, :force => true do |table|
        table.column :schedule_id, :integer
        table.column :expanded_in_library, :boolean, :default => true
        table.column :name, :string
      end

      create_table :resources, :force => true do |table|
        table.column :resource_group_id, :integer
        table.column :displayed_in_planning, :boolean, :default => true
        table.column :email, :string
        table.column :image, :string
        table.column :mobile, :string
        table.column :name, :string
        table.column :phone, :string
      end

      create_table :assignment_groups, :force => true do |table|
        table.column :schedule_id, :integer
        table.column :expanded_in_library, :boolean, :default => true
        table.column :name, :string
      end

      create_table :assignments, :force => true do |table|
        table.column :assignment_group_id, :integer
        table.column :name, :string
        table.column :colour, :string
      end

      create_table :working_times, :force => true do |table|
        table.column :resource_id, :integer
        table.column :assignment_id, :integer
        table.column :begin_date, :date
        table.column :duration, :integer
        table.column :notes, :string
      end

      create_table :holidays, :force => true do |table|
        table.column :schedule_id, :integer
        table.column :resource_id, :integer
        table.column :begin_date, :date
        table.column :end_date, :date
        table.column :name, :string
      end

      create_table :remote_accesses, :force => true do |table|
        table.column :schedule_id, :integer
        table.column :server_id, :integer
        table.column :enabled, :boolean
        table.column :name, :string
        table.column :custom_url, :string
        table.column :custom_enabled, :boolean
        table.column :global_login, :string
        table.column :global_password, :string
      end
    end
  end
end
