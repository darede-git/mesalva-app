# frozen_string_literal: true

class PlatformUnity < ActiveRecord::Base
  include SlugHelper

  belongs_to :platform
  has_many :user_platforms

  has_ancestry orphan_strategy: :rootify

  scope :by_platform_id, ->(platform_id) { where(platform_id: platform_id) }

  scope :root_only, lambda { |root_only = false|
    return where(nil) unless root_only

    where("array_length(string_to_array(ancestry, '/'), 1) is NULL")
  }

  scope :by_parent_id, lambda { |parent_id|
    return where(nil) if parent_id.nil?

    return where("ancestry = :parent_id OR ancestry LIKE :like_parent_id", parent_id: parent_id.to_s, like_parent_id: "%/#{parent_id}")
  }
end
