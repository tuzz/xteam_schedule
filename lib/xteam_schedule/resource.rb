class XTeamSchedule::Resource < ActiveRecord::Base
  belongs_to :resource_group
  
  BASE64_REGEX = /^[a-z0-9=\\]*$/i
  validates_format_of :image, :with => BASE64_REGEX, :message => 'must be valid base64'
  validates :name, :presence => true,
                   :uniqueness => true
end
