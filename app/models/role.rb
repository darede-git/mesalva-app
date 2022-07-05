# frozen_string_literal: true

class Role < ActiveRecord::Base
  include CommonModelScopes
  include SlugHelper

  has_many :user_roles
  has_many :permission_roles
  has_many :permissions, through: :permission_roles
  has_many :users, through: :user_roles

  ALLOWED_ROLE_TYPES = %w[admin persona beta]
  validates :role_type, inclusion: { in: ALLOWED_ROLE_TYPES }, presence: true
end
