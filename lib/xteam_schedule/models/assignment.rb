class XTeamSchedule::Assignment < ActiveRecord::Base
  belongs_to :assignment_group
  has_many :working_times, :dependent => :destroy
  delegate :schedule, :to => :assignment_group
  
  validates :name, :presence => true,
                   :uniqueness => true
  validates_presence_of :kind, :colour
  validate :rgba_colour
  
private
  
  def rgba_colour
    components = colour.split(',').map { |c| Float(c) }
    raise 'invalid' if components.any?(&:nil?) or components.count != 4
    raise 'invalid' if components.any? { |c| c < 0 || c > 1 }
  rescue
    errors.add(:colour, 'does match the RGBA format')
  end
  
end
