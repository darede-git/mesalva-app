# frozen_string_literal: true

class Permission < ActiveRecord::Base
  include CommonModelScopes

  before_save :remove_slashs

  has_many :permission_roles
  has_many :users, through: :user_roles
  has_many :roles, through: :permission_roles
  has_many :user_roles, through: :roles

  validates :context, presence: true
  validates :action, presence: true

  validates_uniqueness_of :action, scope: [:context]

  scope :left_by_role_slug, -> (role_slug) {
    role = Role.find_by_slug(role_slug)
    select(:id, :description, 'context, action, permission_type, role_id')
      .joins("LEFT JOIN permission_roles ON permission_roles.permission_id = permissions.id AND permission_roles.role_id = #{role.id}")
      .order(:context, :action)
  }

  scope :by_user_id, -> (user_id) {
    joins(:user_roles)
      .where("user_roles.user_id = :user_id OR roles.slug = 'all'", user_id: user_id)
      .group(:context, :action, :id)
      .order(:action)
  }

  scope :by_context, -> (context) {
    where(context: Permission.without_slash(context))
  }

  scope :by_action, -> (action) {
    where(action: Permission.without_slash(action))
  }

  def remove_slashs
    self.context = Permission.without_slash(context)
    self.action = Permission.without_slash(action)
  end

  def self.without_slash(str)
    str.gsub('/', '-')
  end

  def self.validate_user(context, action, user)
    joins(:roles)
      .joins("LEFT JOIN user_roles ON user_roles.role_id = roles.id")
      .where(context: Permission.without_slash(context), action: action)
      .where("roles.slug = 'all' OR user_roles.user_id = ?", user.id)
      .count
      .positive?
  end
end
