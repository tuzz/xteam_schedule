class XTeamSchedule::Resource < ActiveRecord::Base
  belongs_to :resource_group
  has_many :working_times, :dependent => :destroy
  delegate :schedule, :to => :resource_group
  
  validates_presence_of :name
  validate :uniqueness_of_name_scoped_to_schedule
  
private
  
  def uniqueness_of_name_scoped_to_schedule
    return unless new_record?
    resource_group = self.resource_group or return
    schedule = resource_group.schedule or return
    resources = schedule.resources or return
  
    if resources.find_by_name(name).present?
      errors.add(:name, 'must be unique within the schedule')
    end
  end
  
end
