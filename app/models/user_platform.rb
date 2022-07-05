# frozen_string_literal: true

class UserPlatform < ActiveRecord::Base
  belongs_to :user
  belongs_to :platform
  belongs_to :platform_unity
  has_secure_token :token
  validates_presence_of :user_id
  validates_presence_of :platform_id
  has_one :user_role

  validates_inclusion_of :role, in: %w[student teacher admin]

  scope :with_user, lambda {
    select([:id, :role, :options, "users.name AS user_name", "users.uid AS user_uid",
            "platforms.slug AS platform_slug", "platforms.name AS platform_name",
            "platforms.theme AS platform_theme"])
      .joins(:user, :platform)
  }

  def self.by_platform(platform)
    UserPlatform.select("user_platforms.id, user_platforms.role, users.name, users.uid")
                .joins(:user)
                .where(platform_id: platform.id)
  end

  def grant_unities_by_names(unity_names)
    MeSalva::Platforms::PlatformUnitiesManager.new(platform).grant_user_to_unities_by_name(user, unity_names, self)
  end
end
