class XTeamSchedule::Holiday < XTeamSchedule::Base
  belongs_to :schedule
  belongs_to :resource

  validates_presence_of :begin_date
  validate :can_not_belong_to_both_schedule_and_resource

private

  def can_not_belong_to_both_schedule_and_resource
    if [schedule, resource].all?
      errors.add(:base, 'Can not belong to both a schedule and a resource')
    end
  end

end
