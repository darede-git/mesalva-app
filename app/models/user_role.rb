# frozen_string_literal: true

class UserRole < ActiveRecord::Base
  include CommonModelScopes

  belongs_to :role
  belongs_to :user
  belongs_to :user_platform
  validates :user_platform_id, uniqueness: true, allow_blank: true
end
