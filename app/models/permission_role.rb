# frozen_string_literal: true

class PermissionRole < ActiveRecord::Base
  include CommonModelScopes

  belongs_to :role
  belongs_to :permission

  validates :role, presence: true, uniqueness: { scope: :permission_id }
  validates :permission, presence: true

  validates_uniqueness_of :role, scope: [:permission]
end
