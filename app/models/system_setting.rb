# frozen_string_literal: true

class SystemSetting < ActiveRecord::Base
  include CommonModelScopes

  validates :key, presence: true
end
