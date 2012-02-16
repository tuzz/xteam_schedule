require 'active_record'

class XTeamSchedule::DB
  
  def self.connect
    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database => ':memory:'
    )
  end
  
  def self.build_schema
    ActiveRecord::Schema.define do
      
      create_table :resource_groups do |table|
        table.column :expanded_in_library, :boolean, :default => true
        table.column :name, :string
      end
      
    end
  end
  
end
