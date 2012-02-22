class XTeamSchedule::Assignment < ActiveRecord::Base
  belongs_to :assignment_group
  has_many :working_times, :dependent => :destroy
  delegate :schedule, :to => :assignment_group
  
  validates :name, :presence => true,
                   :uniqueness => true
  validates_presence_of :kind, :colour
  
  serialize :colour, Hash
  after_initialize :set_default_colour
  before_save :symbolize_colour!
  
private
  
  def set_default_colour
    self.colour = { :red => 0.5, :green => 0.5, :blue => 0.5 } if colour.empty?
  end
  
  def symbolize_colour!
    self.colour = colour.inject({}) { |h, (k, v)| h[k.to_sym] = v; h }
  end
  
end
