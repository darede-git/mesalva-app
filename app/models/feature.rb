# frozen_string_literal: true

class Feature < ActiveRecord::Base
  include SlugHelper
  include CommonModelScopes

  validates :name, :slug, presence: true, allow_blank: false

  has_many :package_features
  has_many :packages, through: :package_features

  scope :with_package_id, lambda { |package_id|
    select("features.*", "package_features.package_id")
      .joins(sanitize_sql(["LEFT JOIN package_features ON
        features.id = package_features.feature_id AND
        package_features.package_id = ?", package_id]))
  }
end
