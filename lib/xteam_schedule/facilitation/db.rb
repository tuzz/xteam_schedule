class XTeamSchedule::DB
  
  def self.connect
    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database => ':memory:'
    )
  end
  
  def self.build_schema
    ActiveRecord::Schema.verbose = false
    ActiveRecord::Schema.define do
      
      create_table :schedules do |table|
      end
      
      create_table :resource_groups do |table|
        table.column :schedule_id, :integer
        table.column :expanded_in_library, :boolean, :default => true
        table.column :name, :string
      end
      
      create_table :resources do |table|
        table.column :resource_group_id, :integer
        table.column :displayed_in_planning, :boolean, :default => true
        table.column :email, :string
        table.column :image, :string
        table.column :mobile, :string
        table.column :name, :string
        table.column :phone, :string
      end
      
      create_table :assignment_groups do |table|
        table.column :schedule_id, :integer
        table.column :expanded_in_library, :boolean, :default => true
        table.column :name, :string
      end
      
      create_table :assignments do |table|
        table.column :assignment_group_id, :integer
        table.column :name, :string
      end
      
      create_table :working_times do |table|
        table.column :resource_id, :integer
        table.column :assignment_id, :integer
        table.column :begin_date, :date
        table.column :duration, :integer
        table.column :notes, :string
      end
      
    end
  end
  
end
