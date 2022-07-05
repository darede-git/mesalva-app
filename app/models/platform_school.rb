# frozen_string_literal: true

class PlatformSchool < ActiveRecord::Base
  belongs_to :platform
  validates_presence_of :platform_id
  validates_presence_of :name
  validates_presence_of :city
end
