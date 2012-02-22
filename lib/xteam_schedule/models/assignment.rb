class XTeamSchedule::Assignment < ActiveRecord::Base
  belongs_to :assignment_group
  has_many :working_times, :dependent => :destroy
  delegate :schedule, :to => :assignment_group
  
  validates :name, :presence => true,
                   :uniqueness => true
  validates_presence_of :kind, :colour
  validate :rgb_colour
  
  serialize :colour, Hash
  after_initialize :set_default_colour
  before_save :symbolize_colour!
  after_validation :float_colour_values!

  alias_attribute :color, :colour
  
private
  
  def set_default_colour
    self.colour = { :red => 0.5, :green => 0.5, :blue => 0.5 } if colour.empty?
  end
  
  def symbolize_colour!
    self.colour = colour.inject({}) { |h, (k, v)| h[k.to_sym] = v; h }
  end
  
  def float_colour_values!
    self.colour = colour.inject({}) { |h, (k, v)| h[k] = v.to_f; h } if colour.class == Hash
  end
  
  def rgb_colour
    is_out_of_range = proc { |c| f = Float(c); f < 0 || f > 1 }
    raise 'invalid' if [:red, :green, :blue].any? { |c| is_out_of_range[colour[c]] }
    raise 'invalid' if colour.count != 3
  rescue
    errors.add(:colour, 'is not a valid rgb hash')
  end
  
end
